import 'package:elearning/ui/My_learning/video_player_popup.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass/glass.dart'; // Import the glass package

class MLPopup extends StatelessWidget {
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
      BuildContext context,
      {Key? key,
      required this.token,
      required this.course_id,
      required this.course_name,
      required this.Cprogress,
      required this.Cdiscrpition,
      required this.courseStartDate,
      required this.courseEndDate,
      required this.course_videourl,
      required this.courseDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Color.fromARGB(60, 252, 249, 249),
      child: contentBox(context).asGlass(
        tintColor: Color.fromARGB(255, 248, 244, 244),
        clipBorderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          const SizedBox(height: 10.0),
          Text(
            course_name ?? 'No course name available',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          LinearProgressIndicator(
             value: double.parse(Cprogress.replaceAll('%', '')) / 100,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 10.0),
          Text(
            Cdiscrpition.isNotEmpty ? removeHtmlTags(Cdiscrpition): 'No description available',
            style: const TextStyle(
              fontSize: 16.0,
               fontWeight: FontWeight.bold,
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
                      // const Icon(Icons.calendar_today),
                      SizedBox(width: 2.0),
                      Text('Start :${courseStartDate?.isEmpty??true? "N/A" : courseStartDate}',style: TextStyle( fontSize: 13.0,
               fontWeight: FontWeight.bold),),
             
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                    
                      SizedBox(width: 5.0),
                      Text('End :${courseEndDate?.isEmpty ?? true ? "N/A" : courseEndDate}', style: TextStyle( fontSize: 13.0,
               fontWeight: FontWeight.bold),),
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
                      Text('Duration: ${courseDuration?.isEmpty ?? true ? "-" : courseDuration}'
,style: TextStyle( fontSize: 13.0,
               fontWeight: FontWeight.bold),),
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
              showDialog(
                context: context,
                builder: (context) => VideoPlayerPopup(
                  course_videourl: course_videourl,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
                child: const Icon(Icons.videocam),
                
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailsPage(token, course_id,course_name),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                child: const Text('Start Course',style: TextStyle(color: Colors.white),),
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
    );
  }
  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
    return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
  }
}
