// import 'package:elearning/ui/My_learning/video_player_popup.dart';
// import 'package:elearning/ui/My_learning/startcourse_content.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:glass/glass.dart'; // Import the glass package

// class MLPopup extends StatelessWidget {
//   final String token;
//   final String course_id;
//   final String course_name;
//   final String Cprogress;
//   final String Cdiscrpition;
//   final String courseStartDate;
//   final String courseEndDate;
//   final String course_videourl;
//   final String courseDuration;

//   const MLPopup(
//       BuildContext context,
//       {Key? key,
//       required this.token,
//       required this.course_id,
//       required this.course_name,
//       required this.Cprogress,
//       required this.Cdiscrpition,
//       required this.courseStartDate,
//       required this.courseEndDate,
//       required this.course_videourl,
//       required this.courseDuration})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       elevation: 0.0,
//       backgroundColor: Color.fromARGB(60, 252, 249, 249),
//       child: contentBox(context).asGlass(
//         tintColor: Color.fromARGB(255, 248, 244, 244),
//         clipBorderRadius: BorderRadius.circular(30.0),
//       ),
//     );
//   }

//   Widget contentBox(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
          
//           const SizedBox(height: 10.0),
//           Text(
//             course_name ?? 'No course name available',
//             style: const TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10.0),
//           LinearProgressIndicator(
//              value: double.parse(Cprogress.replaceAll('%', '')) / 100,
//             backgroundColor: Colors.grey[300],
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//           const SizedBox(height: 10.0),
//           Text(
//             Cdiscrpition.isNotEmpty ? removeHtmlTags(Cdiscrpition): 'No description available',
//             style: const TextStyle(
//               fontSize: 16.0,
//                fontWeight: FontWeight.bold,
//             ),
//           ),
          
//           const SizedBox(height: 20.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // const Icon(Icons.calendar_today),
//                       SizedBox(width: 2.0),
//                       Text('Start :${courseStartDate?.isEmpty??true? "N/A" : courseStartDate}',style: TextStyle( fontSize: 13.0,
//                fontWeight: FontWeight.bold),),
             
//                     ],
//                   ),
//                   const SizedBox(height: 2.0),
//                   Row(
//                     children: [
                    
//                       SizedBox(width: 5.0),
//                       Text('End :${courseEndDate?.isEmpty ?? true ? "N/A" : courseEndDate}', style: TextStyle( fontSize: 13.0,
//                fontWeight: FontWeight.bold),),
//                     ],
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.access_time),
//                       SizedBox(width: 5.0),
//                       Text('Duration: ${courseDuration?.isEmpty ?? true ? "-" : courseDuration}'
// ,style: TextStyle( fontSize: 13.0,
//                fontWeight: FontWeight.bold),),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => VideoPlayerPopup(
//                   course_videourl: course_videourl,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey,
//             ),
//                 child: const Icon(Icons.videocam),
                
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                     final String url = "https://lxp-demo2.raptechsolutions.com/auth/token/index.php?user=username&token=$token&email=email&fn=firstname&ln=lastname";

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           CourseDetailsPage(token, course_id,course_name),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).secondaryHeaderColor,
//                 ),
//                 child: const Text('Start Course',style: TextStyle(color: Colors.white),),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.close,
//                   color: Color.fromARGB(255, 249, 2, 2),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey,
//             ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   String removeHtmlTags(String htmlString) {
//     RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
//     return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
//   }
// }

import 'dart:ffi';

import 'package:elearning/services/auth.dart';
import 'package:elearning/services/profile_service.dart';
import 'package:elearning/ui/My_learning/video_player_popup.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart'; // Import the glass package
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class MLPopup extends StatefulWidget {
  final String token;
  final String course_id;
  final String course_name;
  final String Cprogress;
  final String Cdiscrpition;
  final String courseStartDate;
  final String courseEndDate;
  final String course_videourl;
  final String courseDuration;

  const MLPopup(
      {Key? key,
      required this.token,
      required this.course_id,
      required this.course_name,
      required this.Cprogress,
      required this.Cdiscrpition,
      required this.courseStartDate,
      required this.courseEndDate,
      required this.course_videourl,
      required this.courseDuration, })
      : super(key: key);

  @override
  _MLPopupState createState() => _MLPopupState();
}

class _MLPopupState extends State<MLPopup> {
  bool _isLoading = false;
  int? _userId;
  String? _username;
  String? _firstname;
  String? _lastname;
  String? _studentName;
  String? _studentEmail;
  


 

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchProfileData(widget.token);
  }

  
  Future<void> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      

      setState(() {
        _studentName = data['user_info'][0]['studentname'];
        _studentEmail = data['user_info'][0]['studentemail'];
        
      
        });

        

        
        

      
    } catch (e) {
      print('Error fetching profile data: $e');
      _isLoading = false; // Handle loading state on error
    }
  }


  void _fetchUserId() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      final userInfo = await SiteConfigApiService.getUserId(widget.token);
      setState(() {
        _userId = userInfo['id'];
        _username = userInfo['username'];
     
        _firstname = userInfo['firstname'];
        
        _lastname = userInfo['lastname'] ?? '';
        
        _isLoading = false; // Stop loading
      });
    } catch (error) {
      // Handle errors
      print(error);
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      child: contentBox(context)
      //   // tintColor: Color.fromARGB(255, 255, 255, 255),
      //   clipBorderRadius: BorderRadius.circular(30.0),
      
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10.0),
          Text(
            widget.course_name,
            
            style:  TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          LinearProgressIndicator(
            value: double.parse(widget.Cprogress.replaceAll('%', '')) / 100,
            backgroundColor: Colors.grey[300],
            valueColor:  AlwaysStoppedAnimation<Color>(Theme.of(context).secondaryHeaderColor),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.Cdiscrpition.isNotEmpty
                ? removeHtmlTags(widget.Cdiscrpition)
                : 'No description available',
            style:  TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 2.0),
                      Text(
                        'Start :${widget.courseStartDate.isEmpty ? "N/A" : widget.courseStartDate}',
                        style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      SizedBox(width: 5.0),
                      Text(
                        'End :${widget.courseEndDate.isEmpty ? "N/A" : widget.courseEndDate}',
                        style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      SizedBox(width: 5.0),
                      Text(
                        'Duration: ${widget.courseDuration.isEmpty ? "-" : widget.courseDuration+'hr'}',
                        style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(courseVideourl: widget.course_videourl),
                    ),
                  );

                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.youtube,
                  color: Color.fromARGB(255, 249, 2, 2),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                 Navigator.push( context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailsPage(widget.token, widget.course_id, widget.course_name),
                    ),
                  );

              },

  //               onPressed: () async {
  //                 final String url = "https://lxp-demo2.raptechsolutions.com/auth/token/index.php?user=$_username&token=${widget.token}&email=$_studentEmail&fn=$_firstname&ln=$_lastname";
  //                     try{
  //                        final response = await http.post(    Uri.parse(url),);

  //                         if (response.statusCode == 200) {
  //     // If the server returns a 200 OK response, navigate to the next page
  //                   Navigator.push( context,
  //                   MaterialPageRoute(
  //                     builder: (context) =>
  //                         CourseDetailsPage(widget.token, widget.course_id, widget.course_name),
  //                   ),
  //                 );
  //                         }else {
  //     // Handle the case where the server returns an error
  //     print('Failed to send the request. Status code: ${response.statusCode}');
  //     // You might want to show an error message to the user here
  //   }
  // } catch (e) {
  //   // Handle any exceptions
  //   print('An error occurred: $e');
  //   // You might want to show an error message to the user here
  // }
                 
  //               },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                child: const Text(
                  'Start Course',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.close,
                  color: Color.fromARGB(255, 249, 2, 2),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
    return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
  }
}
