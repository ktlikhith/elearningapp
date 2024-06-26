
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
    //SizedBox(width: 8),
    Expanded(
      child: Text(
        'In Progress: $inProgress',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
   // SizedBox(width: 8),
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

  Widget _buildCourseContent() {
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
                                if (module['completiondata'] != null &&
                                    module['completiondata']['state'] == 1)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                if (module['completiondata'] == null ||
                                    module['completiondata']['state'] != 1)
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(height: 10),
            _activityStatus == null
                ? _buildShimmerCourseContent()
                : _buildActivityStatusText(),
            SizedBox(height: 10),
            _courseContentData == null
                ? _buildShimmerCourseContent()
                : _buildCourseContent(),
          ],
        ),
      ),
    );
  }
}
