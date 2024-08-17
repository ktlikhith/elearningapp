


import 'dart:io';

import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/course_content.dart';
import 'package:elearning/ui/My_learning/pdf_view_screen.dart';
import 'package:elearning/ui/My_learning/video_player_screen.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:elearning/ui/Webview/webview.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import 'package:elearning/services/auth.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchCourseContent();
    _courseImageUrlFuture = _fetchCourseImage();
    _courseDescriptionFuture = _fetchCourseDescription();
  }

 Future<void> _refreshContent() async {
    await _fetchCourseContent();
    _courseImageUrlFuture = _fetchCourseImage();
    _courseDescriptionFuture = _fetchCourseDescription();
    setState(() {});
  }

  Future<void> _fetchCourseContent() async {
    try {
      final courseContentResponse = await CourseContentApiService().fetchCourseContentData(widget.token, widget.courseId);
      if (courseContentResponse.containsKey('course_content')) {
        final List<dynamic> courseContent = courseContentResponse['course_content'];
        if (mounted) {
          setState(() {
            _courseContentData = List<Map<String, dynamic>>.from(courseContent);
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
      return await courseReportApiService.getCourseImageWith_token_id(widget.token, widget.courseId);
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

  Future<Directory> getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory('${directory.path}/Download');
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }
    return downloadDirectory;
  }

  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
    return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
  }

  Future<bool> requestStoragePermission() async {
    if (!(await Permission.storage.status.isGranted)) {
      var status = await Permission.storage.request();
      return status.isGranted;
    } else {
      return true; // Permission already granted
    }
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        print('Storage permission not granted inside the downloadFile');
        return;
      }

      final dio = Dio();
      final downloadDirectory = await getDownloadDirectory();
      final filePath = '${downloadDirectory.path}/$fileName';

      await dio.download(url, filePath);

      print('File downloaded to $filePath');
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.25;

    return Scaffold(
      body:RefreshIndicator(

        triggerMode:   RefreshIndicatorTriggerMode.anywhere,
       onRefresh: _refreshContent, // Add this line
      child:FutureBuilder<String>(
        
        future: _courseImageUrlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerImage(imageHeight);
          } else if (snapshot.hasError) {
            return Center(child: Text('Smething went wrong try Again!!'));//Error: ${snapshot.error}
          } else {
            final imageUrl = snapshot.data!;
            return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: imageHeight,
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
                  ),
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
                                  fontSize: 16.0,
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
                        _courseContentData != null ? _buildCourseContent() : _buildShimmerCourseContent(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var section in _courseContentData!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    section['expanded'] = !(section['expanded'] ?? false);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                   // color: Colors.grey[200],
                   
                   color: Theme.of(context).hintColor.withOpacity(0.4),
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
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      
                       SizedBox(
                        
                     
                width: 32, // Set the width of the circular progress indicator
                height: 32, // Set the height of the circular progress indicator
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    
                    CircularProgressIndicator(
                      
                      value:      (() {
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
                ),
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
                
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: Column(
                    
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
                                    Icon(Icons.check_circle, color: Colors.green,size: 18,),
                                  if (module['completiondata'] == null || module['completiondata']['state'] == 0)
                                    Icon(Icons.radio_button_unchecked, color: Colors.grey,size: 18,),
                                  SizedBox(width: 8),
                                  _buildModuleIcon(module['modname']),
                                ],
                              ),
                              title: Text(
                                module['name'] ?? 'Module Name',
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
                                            DownloadManager.downloadFile(
                                              context,
                                              fileurl,
                                              content['filename'],
                                              widget.token,
                                              widget.courseName
                                            );
                                          }
                                        }
                                      },
                                    ),
                                ],
                              ),
                              onTap: () {
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
                                   Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>WebViewPage(module['name'],  module['url'], widget.token,))
                              );
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
                                   Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>WebViewPage(module['name'] ?? 'resource',  module['url'], widget.token,pdfurl))
                              );
                                } else if (module['modname'] == 'customcert' ){
                              // String certificateurl=module['url']+'&forcedownload=1';

                              
                              //    Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => WebViewPage(   module['name'] ?? 'customcert',  module['url'],widget.token, ),
                              //       ),
                              //     );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>WebViewPage(module['name'] ?? 'customcert',  module['url'], widget.token,))
                              );
                                }
                                else if (module['modname'] == 'zoom' || module['modname'] == 'googlemeet') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'Meeting', module['url'],widget.token),
                                    ),
                                  );
                                } else if (module['modname'] == 'forum') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'Forum', module['url'],widget.token),
                                    ),
                                  );
                                } else if (module['modname'] == 'quiz') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'Quiz', module['url'],widget.token),
                                    ),
                                  );
                                } else if (module['modname'] == 'assign' && module['contents'] != null && module['contents'].isNotEmpty) {
                                  final moduleContent = module['contents'][0];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'Assignment', module['url'],widget.token),
                                    ),
                                  );
                                } else if (module['modname'] == 'scorm' && module['contents'] != null && module['contents'].isNotEmpty) {
                                  final content = module['contents'][0];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'SCORM', content['fileurl'],widget.token),
                                    ),
                                  );
                                } else if (module['modname'] == 'assign') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(module['name'] ?? 'Assignment', module['url'],widget.token),
                                    ),
                                  );
                                } else {
                                  if (module['url'] != null && module['url'].isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage(module['name'] ?? 'Module Name', module['url'],widget.token),
                                      ),
                                    );
                                  }
                                }
                              },
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
}
