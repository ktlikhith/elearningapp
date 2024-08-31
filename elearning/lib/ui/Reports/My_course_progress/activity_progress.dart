
// import 'dart:io';

// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/allcourse_service.dart';
// import 'package:elearning/services/course_content.dart';
// import 'package:elearning/ui/My_learning/pdf_view_screen.dart';
// import 'package:elearning/ui/My_learning/video_player_screen.dart';
// import 'package:elearning/ui/Webview/testweb.dart';
// import 'package:elearning/ui/Webview/webview.dart';
// import 'package:elearning/ui/download/downloadmanager.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shimmer/shimmer.dart';

// import 'package:elearning/services/auth.dart';

// class ActivityDetailsPage extends StatefulWidget {
//   final String token;
//   final String courseId;
//   final String courseName;

//   ActivityDetailsPage(this.token, this.courseId, this.courseName);

//   @override
//   _ActivityDetailsPageState createState() => _ActivityDetailsPageState();
// }

// class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
//   List<Map<String, dynamic>>? _courseContentData;


//   @override
//   void initState() {
//     super.initState();
//     _fetchCourseContent();
   
//   }

//   Future<void> _fetchCourseContent() async {
//     try {
//       final courseContentResponse = await CourseContentApiService().fetchCourseContentData(widget.token, widget.courseId);
//       if (courseContentResponse.containsKey('course_content')) {
//         final List<dynamic> courseContent = courseContentResponse['course_content'];
//         final  activitystatus=courseContentResponse['activitystatus'];
//         if (mounted) {
//           setState(() {
//             _courseContentData = List<Map<String, dynamic>>.from(courseContent);
             
//           });
//         }
//       } else {
//         throw Exception('Response does not contain course content');
//       }
//     } catch (e) {
//       print('Error fetching course content: $e');
//     }
//   }

 

 

 



 

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final imageHeight = screenHeight * 0.25;

//     return Scaffold(
//          appBar: AppBar(
//       title: Text('Activity Status'),
//       backgroundColor: Theme.of(context).primaryColor,
//       centerTitle: false,
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//     ),
//       body: 
       
        
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
                 
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
                       
//                         _courseContentData != null ? _buildCourseContent() : _buildShimmerCourseContent(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//           }
  


 

//  Widget _buildCourseContent() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//       for (var section in _courseContentData!)
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).hintColor.withOpacity(0.4),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Text(
//                         section['name'] ?? 'Section Name',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color.fromARGB(220, 6, 6, 6),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
                
//                 ],
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).hintColor.withOpacity(0.2),
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   for (var module in section['modules'])
//                     Column(
//                       children: [
//                         ListTile(
//                           leading: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               if (module['completiondata'] != null && module['completiondata']['state'] == 1)
//                                 Icon(Icons.check_circle, color: Colors.green, size: 18,),
//                               if (module['completiondata'] == null || module['completiondata']['state'] != 1)
//                                 Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 18,),
//                               SizedBox(width: 8),
//                               _buildModuleIcon(module['modname']),
//                             ],
//                           ),
//                           title: Text(
//                             module['name'] ?? 'Module Name',
//                             style: TextStyle(
//                               color: Color.fromARGB(255, 6, 6, 6),
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//     ],
//   );
// }


//   Widget _buildShimmerCourseContent() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           for (int i = 0; i < 5; i++)
//             Column(
//               children: [
//                 Container(
//                   height: 20,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(height: 8),
//                 Container(
//                   height: 20,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModuleIcon(String? modname) {
//     String iconPath;
//     switch (modname) {
//       case 'videofile':
//         iconPath = 'assets/Activity icons/Video.png';
//         break;
//       case 'customcert':
//       case 'iomadcertificate':
//         iconPath = 'assets/Activity icons/certificate.png';
//         break;
//       case 'resource':
//         iconPath = 'assets/Activity icons/pdf-96 (1).png';
//         break;
//       case 'zoom':
//         iconPath = 'assets/Activity icons/zoom.png';
//         break;
//       case 'googlemeet':
//         iconPath = 'assets/Activity icons/google-meet.png';
//         break;
//       case 'forum':
//         iconPath = 'assets/Activity icons/forum.png';
//         break;
//       case 'quiz':
//         iconPath = 'assets/Activity icons/questions.png';
//         break;
//       case 'assign':
//         iconPath = 'assets/Activity icons/assignment.png';
//         break;
//       case 'scorm':
//         iconPath = 'assets/Activity icons/scorm package.png';
//         break;
//       case 'page':
//         iconPath = 'assets/Activity icons/file.png';
//         break;
//       case 'h5pactivity':
//         iconPath = 'assets/Activity icons/H5P.png';
//         break;
//       case 'goone':
//         iconPath = 'assets/Activity icons/goone.png';
//         break;
//       case 'game':
//         iconPath = 'assets/Activity icons/game.png';
//         break;
//       default:
//         iconPath = 'assets/Activity icons/ILT.png';
//         break;
//     }

//     return Image.asset(
//       iconPath,
//       width: 26,
//       height: 26,
//       fit: BoxFit.cover,
//     );
//   }
// }


import 'dart:io';

import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/pdf_view_screen.dart';
import 'package:elearning/ui/My_learning/video_player_screen.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:elearning/services/course_content.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String token;
  final String courseId;
  final String courseName;

  ActivityDetailsPage(this.token, this.courseId, this.courseName);

  @override
  _ActivityDetailsPageState createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  List<Map<String, dynamic>>? _courseContentData;
  Map<String, dynamic>? _activityStatus;

  @override
  void initState() {
    super.initState();
    _fetchCourseContent();
  }

  Future<void> _fetchCourseContent() async {
    try {
      final courseContentResponse = await CourseContentApiService()
          .fetchCourseContentData(widget.token, widget.courseId);
      if (courseContentResponse.containsKey('course_content')) {
        final List<dynamic> courseContent =
            courseContentResponse['course_content'];
        final activityStatus = courseContentResponse['activitystatus'];
        if (mounted) {
          setState(() {
            _courseContentData =
                List<Map<String, dynamic>>.from(courseContent);
            _activityStatus = activityStatus;
          });
        }
      } else {
        throw Exception('Response does not contain course content');
      }
    } catch (e) {
      print('Error fetching course content: $e');
    }
  }

  Widget _buildActivityStatusText() {
    if (_activityStatus == null) return SizedBox.shrink();

    final int completed = _activityStatus!['completedactivity'];
    final int inProgress = _activityStatus!['inprogressactivity'];
    final int total = _activityStatus!['totalactivity'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Status',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        
          SizedBox(height: 10),
          _buildProgressBar('Completed', completed, total, const Color.fromARGB(255, 47, 208, 52)),
          SizedBox(height: 8),
          _buildProgressBar('In Progress', inProgress, total, Color.fromARGB(255, 241, 143, 6)),
          SizedBox(height:10 ,),
            Row(
            children: [
              Expanded(
                child: Text(
                  'Completed: $completed',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'In Progress: $inProgress',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Total: $total',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value/$total',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / total,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 16,
        ),
      ],
    );
  }

  Widget _buildCourseContent() {
    bool islandscape=MediaQuery.of(context).orientation==Orientation.landscape;
    if (_courseContentData == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var section in _courseContentData!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
                            color: Color.fromARGB(220, 6, 6, 6),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: Stack(
                    children:[ Padding(
                      padding:  EdgeInsets.only(top:22,left:22.5 ),
                      child: Stack(children:[ Container(width: 5,height: section['modules'].length!=0?((section['modules'].length-1)*57.5):0.0,color: Theme.of(context).cardColor.withOpacity(0.35)),
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
                              else
                              return completedModules*56.5;
                                }
                              else {
                                return 0.0;
                              }
                             
                                 })(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                     color: Colors.green,
                    ),
                  ),]),
                    ),Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var module in section['modules'])
                      Column(
                        children: [
                          ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (module['completiondata'] != null &&
                                    module['completiondata']['state'] !=0)
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                if (module['completiondata'] == null ||
                                    module['completiondata']['state'] == 0)
                                  Icon(
                                    Icons.circle,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                SizedBox(width: 8),
                                _buildModuleIcon(module['modname']),
                              ],
                            ),
                            title: Text(
                              module['name'] ?? 'Module Name',maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromARGB(255, 6, 6, 6),
                                fontSize: 17,
                              ),
                            ),
                            
                              onTap: () {
                                if (module['modname'] == 'videofile' && module['contents'] != null && module['contents'].isNotEmpty) {
                                  final content = module['contents'][0];
                                  String getdwnloadUrlWithToken(String filePath1, String Token) {
                                    return '$filePath1&token=$Token';
                                  }
                                  String vidurl = getdwnloadUrlWithToken(module['contents'][0]['fileurl'], widget.token);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(vidurl: vidurl),
                                    ),
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
                          //);
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=>WebViewPage(module['name'] ?? 'resource',  module['url'], widget.token,pdfurl))
                                  
                                  );
                                } else if (module['modname'] == 'customcert' ){
                              String certificateurl=module['url']+'&forcedownload=1';

                              
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage(   module['name'] ?? 'customcert',  module['url'],widget.token, ),
                                    ),
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
                    ]
                )
              ),
              SizedBox(height: 10),
            ],
          ),
      ],
  
    );
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
  Future<void> _refreshContent() async {
    await _fetchCourseContent();
    _activityStatus == null
                ? _buildShimmerCourseContent()
                : _buildActivityStatusText();
            _courseContentData == null
                ? _buildShimmerCourseContent()
                : _buildCourseContent();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: RefreshIndicator(
         triggerMode:RefreshIndicatorTriggerMode.anywhere,
      
      onRefresh: _refreshContent,
      child:SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 10),
            _activityStatus == null
                ? _buildShimmerCourseContent()
                : _buildActivityStatusText(),
            _courseContentData == null
                ? _buildShimmerCourseContent()
                : _buildCourseContent(),
          ],
        ),
      ),
      ),
    );
  }
}
