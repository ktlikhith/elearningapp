



import 'package:elearning/services/auth.dart';
import 'package:elearning/services/profile_service.dart';

import 'package:elearning/ui/My_learning/video_player_popup.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
   bool is_course_videourl=false;
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
     if(widget.course_videourl!=""){
        is_course_videourl=true;
      }
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
              color: Theme.of(context).primaryColor
            ),
          ),
          const SizedBox(height: 10.0),
          LinearProgressIndicator(
            value: double.parse(widget.Cprogress.replaceAll('%', '')) / 100,
            backgroundColor: Colors.grey[300],
            valueColor:  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
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
  mainAxisAlignment: MainAxisAlignment.center,
  children: [ 
    ElevatedButton(
      onPressed: is_course_videourl ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YouTubePlayerScreen(videoUrl: widget.course_videourl),
          ),
        );
      } : () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).hintColor,
      ),
      child: const FaIcon(
        FontAwesomeIcons.youtube,
        color: Color.fromARGB(255, 249, 2, 2),
      ),
    ),
    SizedBox(width: 8.0), // Space between buttons
    Expanded(
      child: ElevatedButton(
        onPressed: ()async{
              Navigator.pop(context);  
        await  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(widget.token, widget.course_id, widget.course_name),
            ),
          );
       
         
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Start',
                  style: TextStyle(color: Theme.of(context).highlightColor,fontSize: 13.4),
                ),
                SizedBox(width: 4,),
                 Icon(FontAwesomeIcons.play,size: 15,color:Theme.of(context).highlightColor ,),
              ],
            ),
            
          ],
        ),
      ),
    ),
    SizedBox(width: 8.0), // Space between buttons
    ElevatedButton(
      child: const FaIcon(
        FontAwesomeIcons.close,
        color: Color.fromARGB(255, 249, 2, 2),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).hintColor,
      ),
    ),
  ],
)

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
