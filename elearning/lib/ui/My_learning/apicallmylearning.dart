// import 'package:elearning/ui/My_learning/course.dart';
// import 'package:flutter/material.dart';
// import 'package:elearning/widgets/course_section.dart'; // Import your course section widget

// class MyPage extends StatefulWidget {
//   @override
//   _MyPageState createState() => _MyPageState();
// }

// class _MyPageState extends State<MyPage> {
//   late Video video; // Declare the Video instance

//   @override
//   void initState() {
//     super.initState();
//     // Assume you are fetching data from an API or any other data source
//     fetchVideoData().then((retrievedVideo) {
//       setState(() {
//         video = retrievedVideo;
//       });
//     });
//   }

//   Future<Video> fetchVideoData() async {
//     // Simulated API call or data retrieval process
//     await Future.delayed(Duration(seconds: 2)); // Simulate loading delay
//     return Video(
//       title: 'Sample Video Title',
//       duration: '2h 30m',
//       videoUrl: 'https://www.example.com/sample-video',
//       status: 'In Progress',
//       dueDate: '2024-03-25',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Page'),
//       ),
//       body: video != null // Check if video data is available
//           ? buildCourseSection(video) // Build the course section with video data
//           : Center(child: CircularProgressIndicator()), // Show loading indicator if data is loading
//     );
//   }
// }
