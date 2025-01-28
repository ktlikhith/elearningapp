
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/providers/Reward_data_provider.dart';
import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/providers/eventprovider.dart';
import 'package:elearning/providers/profile_provider.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/course_content.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer' as developer;

class CourseDetailsPage extends StatefulWidget {
  final String token;
  final String courseId;
  final String courseName;

  CourseDetailsPage(this.token, this.courseId, this.courseName);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  List<Map<String, dynamic>>? _courseContentData;
  late Future<String> _courseImageUrlFuture;
  late Future<String> _courseDescriptionFuture;
  String imgurl='';
     ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;
  bool _iscontentloading=true;
   int? _expandedIndex;

  @override
  void initState() {
    super.initState();
   
      initConnectivity();
    
      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
     DownloadManager dm =DownloadManager();
    _fetchCourseContent();
    _courseImageUrlFuture = _fetchCourseImage();
    _courseDescriptionFuture = _fetchCourseDescription();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
    @override
  void dispose() {
      _connectivitySubscription.cancel(); 
// to stop audio and video
 setState(() {});
    super.dispose();
  }
   
  // Initialize connectivity
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  // Update connectivity status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _dismissNoInternetDialog();
    }
  }

  // Show No Internet Dialog
  void _showNoInternetDialog() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opss No Internet Connection..'),
            content: const Text('Please check your connection. You can try reloading the page or explore the available offline content.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Reload'),
                onPressed: () 
                {  _refreshContent();},
                // onPressed: () async {
                //   final result = await _connectivity.checkConnectivity();
                //   _updateConnectionStatus(result);
                // },
              ),
              ElevatedButton(onPressed:(){  Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);}, child:  const Text('Offline Content'),)
              
            ],
          );
        },
      );
    }
  }

  // Dismiss No Internet Dialog
  void _dismissNoInternetDialog() {
    if (isDialogOpen) {
    _refreshContent();
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
  }


 Future<void> _refreshContent() async {
    // await _fetchCourseContent();
    _iscontentloading=true;
    _courseImageUrlFuture = _fetchCourseImage();
    _courseDescriptionFuture = _fetchCourseDescription();
    setState(() {
        _fetchCourseContent();
    });
  }

  Future<void> _fetchCourseContent() async {
    try {
      final courseContentResponse = await CourseContentApiService().fetchCourseContentData(widget.token, widget.courseId);
      if (courseContentResponse.containsKey('course_content')) {
        final List<dynamic> courseContent = courseContentResponse['course_content'];
        if (mounted) {
          setState(() {
            _courseContentData = List<Map<String, dynamic>>.from(courseContent);
            _iscontentloading=false;
          });
        }
      } else {
        throw Exception('Response does not contain course content');
      }
    } catch (e) {
      print('Error fetching course content: $e');
    }
  }

   Future<String> _fetchCourseImage() async {
    try {
      CourseReportApiService courseReportApiService = CourseReportApiService();
      return courseReportApiService.getCourseImageWith_token_id(widget.token, widget.courseId);
    } catch (e) {
      throw Exception('Error fetching course image: $e');
    }
  }

  Future<String> _fetchCourseDescription() async {
    try {
      CourseReportApiService courseReportApiService = CourseReportApiService();
      return await courseReportApiService.getCourseDescriptionWith_token_id(widget.token, widget.courseId);
    } catch (e) {
      throw Exception('Error fetching course description: $e');
    }
  }


  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
    return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
  }




  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.25;

    return Scaffold(
      body:RefreshIndicator(

        triggerMode:   RefreshIndicatorTriggerMode.anywhere,
       onRefresh: _refreshContent, // Add this line
      child:
      SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<String>(
              
              future: _courseImageUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerImage(imageHeight);
                } else if (snapshot.hasError) {
                  return _buildShimmerImage(imageHeight);//Error: ${snapshot.error}
                } else {
                  final imageUrl = snapshot.data!;
                  
                    imgurl=imageUrl;
                  
                  return Stack(
                    children: [
                      Container(
                        height:MediaQuery.of(context).orientation==Orientation.landscape?screenHeight * 0.6: imageHeight,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/coursedefaultimg.jpg',
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              widget.courseName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            FutureBuilder<String>(
                              future: _courseDescriptionFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _buildShimmerDescription();
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('No description available'));
                                } else {
                                  final description = snapshot.data!;
                                  return Text(
                                    description.isNotEmpty ? removeHtmlTags(description) : 'No description available',
                                    style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.5,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  );
                                }
                              },
                            ),
                            Divider(),
                            SizedBox(height: 8),
                            Text(
                              'Course Content',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Color.fromARGB(255, 12, 12, 12),
                              ),
                            ),
                            SizedBox(height: 8),
                            _iscontentloading != true ? _buildCourseContent() : _buildShimmerCourseContent(),
                          ],
                        ),
                      ),
                    ],
                  ),
               
          
        ),
      ),
    
    );
  }

  Widget _buildShimmerImage(double imageHeight) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: imageHeight,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildShimmerDescription() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Container(
            height: 20,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContent() {
    bool _landscape=MediaQuery.of(context).orientation==Orientation.landscape;
    int i=0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var section in _courseContentData!)

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  //  if(section['modules'].length!=0)
                  //   setState(() {
                  //   section['expanded'] = !(section['expanded'] ?? null);
                  // });
                 
                    if (section['modules'].length != 0) {
      setState(() {
        // Collapse all other sections
        for (var sec in _courseContentData!) {
          if( sec['expanded']!=section['expanded'] )
          sec['expanded'] = false;
        }
        // Expand the current section
        section['expanded'] = !(section['expanded'] ?? false);
      });
    }
                
                  
                },
                child: Container(
                  decoration: BoxDecoration(
                   // color: Colors.grey[200],
                   
                   color: Theme.of(context).cardColor,
                    borderRadius: section['expanded'] ?? false ? BorderRadius.vertical(top: Radius.circular(10)) : BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            section['name'] ?? 'Section Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).highlightColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      
                       SizedBox(
                      
                        
                     
                width: 32, // Set the width of the circular progress indicator
                height: 32, // Set the height of the circular progress indicator
                child:   section['name']!='General'?Stack(
                  fit: StackFit.expand,
                  children: [
                    
                    CircularProgressIndicator(
                           
                      
                      value:      (() {
                         int completedModules = section['modules'].where((module) =>
                                    module['completiondata'] != null &&
                                    module['completiondata']['state'] != 0).length;
                            int totalModules = section['modules'].length;
                           int sectionprogress = 0;
                                  if (totalModules > 0) {
                        sectionprogress = ((100 * completedModules) / totalModules).toInt();
                                            }
                              return sectionprogress/100;
                                 })(), 
                      strokeWidth: 3,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(   (() {
                         int completedModules = section['modules']
                                .where((module) =>
                                    module['completiondata'] != null &&
                                    module['completiondata']['state'] != 0)
                                .length;
                            int totalModules = section['modules'].length;
                            int sectionprogress = 0;
                   if (totalModules > 0) {
                    sectionprogress = ((100 * completedModules) / totalModules).toInt();
                          }
                              return sectionprogress;
                                 })(),),
                      ),
                    ),
                    Center(
                      child: Text(
                              (() {
                         int completedModules = section['modules']
                                .where((module) =>
                                    module['completiondata'] != null &&
                                    module['completiondata']['state'] != 0)
                                .length;
                            int totalModules = section['modules'].length;
                              return "($completedModules/$totalModules)";
                                 })(),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(   (() {
                         int completedModules = section['modules']
                                .where((module) =>
                                    module['completiondata'] != null &&
                                    module['completiondata']['state'] != 0)
                                .length;
                            int totalModules = section['modules'].length;
                            int sectionprogress = 0;
                   if (totalModules > 0) {
                    sectionprogress = ((100 * completedModules) / totalModules).toInt();
                          }
                              return sectionprogress;
                                 })(),),
                        ),
                      ),
                    ),
                  ],
                ):Container(),
              ),
                    
                      Icon(
                        section['expanded'] ?? false
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Color.fromARGB(255, 6, 6, 6),
                        size: 30,
                      ),
                      
                    ],
                  ),
                ),
              ),
               
              if (section['expanded'] ?? false)
                Container(
                  decoration: BoxDecoration(
                   // color: Colors.grey[100],
                   color: Theme.of(context).hintColor.withOpacity(0.2),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                
                  padding:  EdgeInsets.symmetric(vertical: 0, horizontal: MediaQuery.of(context).size.width*0.005),
                  child: Stack(
                    children:[ Padding(
                      padding:  EdgeInsets.only(top:22,left:22.5 ),
                      child: Stack(children:[Container(width: 5,height: section['modules'].length!=0?((section['modules'].length-1)*56.5):0.0,color: Theme.of(context).cardColor.withOpacity(0.35)),
                        Container(
                    width: 5,
                    height:   section['modules'].length==1?0: (() {
                         int completedModules = section['modules']
                                .where((module) =>
                                    module['completiondata'] != null &&
                                    module['completiondata']['state'] != 0)
                                .length;
                                if(completedModules!=0){
                                  if(completedModules== section['modules'].length)
                              return (completedModules-1)*56.5;
                              else if(section['modules'].length!=1)
                              return completedModules*56.5;
                                }
                              else {
                                return 0.0;
                              }
                             
                                 })(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                     color: Theme.of(context).cardColor,
                    ),
                  ),
                    ]),
                      
                    ), Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        for (var module in section['modules'])
                          Column(
                            children: [
                             
                                  ListTile(
                                  leading: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                     
                                      if (module['completiondata'] != null && module['completiondata']['state'] != 0)
                                        Icon(Icons.circle, color: Theme.of(context).cardColor,size: 18,),
                                      if (module['completiondata'] == null || module['completiondata']['state'] == 0)
                                        Icon(Icons.circle, color: Colors.grey,size: 18,),
                                    
                                      SizedBox(width: 8),
                                      Container( height: 20,width: 20,child:_buildModuleIcon(module['modname'])),
                                    ],
                                  ),
                                  title: Text(
                                    module['name'] ?? 'Module Name',maxLines: 1,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      
                                      color: Color.fromARGB(255, 6, 6, 6),
                                      fontSize: 17,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (module['contents'] != null )
                                        IconButton(
                                          icon: const FaIcon(FontAwesomeIcons.download, color: Colors.black, size: 16.5),
                                          onPressed: () {
                                            if (module['contents'] != null && module['contents'].isNotEmpty) {
                                              final content = module['contents'][0];
                                              if (content['fileurl'] != null && content['filename'] != null) {
                                                String getdwnloadUrlWithToken(String filePath1, String Token) {
                                                  return '$filePath1&token=$Token';
                                                }
                                                String fileurl = getdwnloadUrlWithToken(content['fileurl'], widget.token);
                                                DownloadManager dm =DownloadManager();
                                                dm.downloadFile(
                                                  context,
                                                  fileurl,
                                                  content['filename'],
                                                  widget.token,
                                                  widget.courseName,
                                                  imgurl
                                                );
                                  //                 Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context)=>ImageDisplayExample())
                                  // );
                                             
                                              }
                                         
                                            }
                                          },
                                        ),
                                        
                                    ],
                                  ),
                                  onTap: () async{
                                     bool uservisible =
                                    module['uservisible'] ;
                                    bool availabilityinfo=module['availabilityinfo']!=null;

                                    print(uservisible);
                                    if(uservisible){
                                    if (module['modname'] == 'videofile' && module['contents'] != null && module['contents'].isNotEmpty) {
                                      // final content = module['contents'][0];
                                      // String getdwnloadUrlWithToken(String filePath1, String Token) {
                                      //   return '$filePath1&token=$Token';
                                      // }
                                      // String vidurl = getdwnloadUrlWithToken(module['contents'][0]['fileurl'], widget.token);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => VideoPlayerScreen(vidurl: vidurl),
                                      //   ),
                                      // );   
                      
                              
                                    await   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>WebViewPage(module['name'],  module['url'], widget.token,))
                                  );
                         updatedata();
                                    } else if ( module['modname'] == 'resource' && module['contents'] != null && module['contents'].isNotEmpty) {
                                      final content = module['contents'][0];
                                      String getpdfUrlWithToken(String filePath1, String Token) {
                                        return '$filePath1&token=$Token';
                                      }
                                      String pdfurl = getpdfUrlWithToken(module['contents'][0]['fileurl'], widget.token,);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => PDFViewScreen(pdfurl),
                                      //   ),
                                      // );
                                     await  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>WebViewPage(module['name'] ?? 'resource',  module['url'], widget.token,pdfurl))
                                  );
                              updatedata();
                                    } else if (module['modname'] == 'customcert' ){
                                  // String certificateurl=module['url']+'&forcedownload=1';
                                
                                  
                                  //    Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => WebViewPage(   module['name'] ?? 'customcert',  module['url'],widget.token, ),
                                  //       ),
                                  //     );
                                await  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>WebViewPage(module['name'] ?? 'customcert',  module['url'], widget.token,))
                                  );
                               updatedata();
                                    }
                                    else if (module['modname'] == 'zoom' || module['modname'] == 'googlemeet') {
                                    await  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'Meeting', module['url'],widget.token),
                                        ),
                                      );
                                        updatedata();
                                    } else if (module['modname'] == 'forum') {
                                     await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'Forum', module['url'],widget.token),
                                        ),
                                      );
                                        updatedata();
                                    } else if (module['modname'] == 'quiz') {
                                    await  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'Quiz', module['url'],widget.token),
                                        ),
                                      );
                                       updatedata();

                                    } else if (module['modname'] == 'assign' && module['contents'] != null && module['contents'].isNotEmpty) {
                                      final moduleContent = module['contents'][0];
                                     await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'Assignment', module['url'],widget.token),
                                        ),
                                      );
                                       updatedata();
                                    } else if (module['modname'] == 'scorm' && module['contents'] != null && module['contents'].isNotEmpty) {
                                      final content = module['contents'][0];
                                     await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'SCORM', content['fileurl'],widget.token),
                                        ),
                                      );
                                       updatedata();
                                    } else if (module['modname'] == 'assign') {
                                    await  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage(module['name'] ?? 'Assignment', module['url'],widget.token),
                                        ),
                                      );
                                      updatedata();
                                    } else {
                                      if (module['url'] != null && module['url'].isNotEmpty) {
                                      await  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebViewPage(module['name'] ?? 'Module Name', module['url'],widget.token),
                                          ),
                                        );
                                        updatedata();
                                      }
                                    }
                                  }
                                  else if(availabilityinfo){
                                     String requiredurl=module['availabilityinfo'].split('?id=')[1];
                                     String requiredid=requiredurl.split('\">')[0];
                                      final modu= section['modules'].firstWhere(
    (module) => module['id'] == requiredid, 
    orElse: () => null, // Returns null if no match found
  );
                                     String requirednmae=modu!=null?modu['name']:'';
                                     Showerrordialog(context,'Not available unless:','The activity ${requirednmae} is marked complete');
                                  }
                                  else{
                                    Showerrordialog(context,'No Access to this activity','Your not allowed to access this activity without completing the previous one...!!\n If your already completed then make sure that you marked it as completed..!! ');
                                  }
                                   }
                                  
                                ),
                                
                                
                              
                             
                              
                            ],
                          ),
                      ],
                      
                    ),
                   
                    ],
                  ),
                ),
              SizedBox(height: 10),
            ],
          ),
      ],
    );
  }

  Color _getStatusColor(int progress) {
    if (progress == 0) {
      return Colors.red;
    } else if (progress == 100) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
  Widget _buildShimmerCourseContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 5; i++)
            Column(
              children: [
                Container(
                  height: 20,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Container(
                  height: 20,
                  color: Colors.grey,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildModuleIcon(String? modname) {
    String iconPath;
    switch (modname) {
      case 'videofile':
        iconPath = 'assets/Activity icons/Video.png';
        break;
      case 'customcert':
      case 'iomadcertificate':
        iconPath = 'assets/Activity icons/certificate.png';
        break;
      case 'resource':
        iconPath = 'assets/Activity icons/pdf-96 (1).png';
        break;
      case 'zoom':
        iconPath = 'assets/Activity icons/zoom.png';
        break;
      case 'googlemeet':
        iconPath = 'assets/Activity icons/google-meet.png';
        break;
      case 'forum':
        iconPath = 'assets/Activity icons/forum.png';
        break;
      case 'quiz':
        iconPath = 'assets/Activity icons/questions.png';
        break;
      case 'assign':
        iconPath = 'assets/Activity icons/assignment.png';
        break;
      case 'scorm':
        iconPath = 'assets/Activity icons/scorm package.png';
        break;
      case 'page':
        iconPath = 'assets/Activity icons/file.png';
        break;
      case 'h5pactivity':
        iconPath = 'assets/Activity icons/H5P.png';
        break;
      case 'goone':
        iconPath = 'assets/Activity icons/goone.png';
        break;
      case 'game':
        iconPath = 'assets/Activity icons/game.png';
        break;
      default:
        iconPath = 'assets/Activity icons/ILT.png';
        break;
    }

    return Image.asset(
      iconPath,
      width: 26,
      height: 26,
      fit: BoxFit.cover,
    );
  }
   updatedata()async{
      context.read<LearningPathProvider>().fetchLearningPaths();
      context.read<HomePageProvider>().fetchAllCourses();
     context.read<ProfileProvider>().fetchProfileData();
       context.read<ReportProvider>().fetchData();
          context.read<EventProvider>().fetchEvent();
           context.read<RewardProvider>().fetchRewardPoints();
              context.read<RewardProvider>().fetchSpinWheelData();
            setState(() {
                       _connectivitySubscription =
                      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
                       DownloadManager dm =DownloadManager();
                      _fetchCourseContent();
                    _courseImageUrlFuture = _fetchCourseImage();
                    _courseDescriptionFuture = _fetchCourseDescription();
                                                         });
  }
}
