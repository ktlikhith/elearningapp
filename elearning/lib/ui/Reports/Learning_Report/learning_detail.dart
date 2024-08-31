import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';

class LearningPathDetailScreen extends StatefulWidget {
  final LearningPathDetail learningPath;
  final String token;


  LearningPathDetailScreen({Key? key, required this.token,required this.learningPath}) : super(key: key);

  @override
  _LearningPathDetailScreenState createState() => _LearningPathDetailScreenState();
}

class _LearningPathDetailScreenState extends State<LearningPathDetailScreen> {

  
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course> _courses = [];

 @override
  void initState() {
    super.initState();
    
    _fetchCourses(widget.token);
  }

  Future<void> _fetchCourses(String token) async {
    try {
      final List<Course> response = await _apiService.fetchCourses(token);
      if (mounted) {
        setState(() {
          _courses = response;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      // Handle error here
    }
  }
  

  @override
  Widget build(BuildContext context) {
    List<LearningPathProgress> courses = widget.learningPath.learningpathProgress;
    List<Course> allcourses= _courses;
    
    
  
    

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.learningPath.name),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: courses.isEmpty
          ? Center(child: Text('No courses available'))
          : Stack(
            children:[  Padding(
                        padding:  EdgeInsets.only(top:40,left:23 ),
                        child: Stack(children:[Container(width: 5,height: courses.length!=0?((courses.length-1)*100):0.0,color: Theme.of(context).cardColor.withOpacity(0.35)),
                          Container(
                      width: 5,
                      height:   courses.length==1?0: (() {
                        int completedcourse=courses.where((course)=>course.progress==100).length;
                           
                                  if(completedcourse!=0){
                                  if(completedcourse==courses.length)
                                return (completedcourse-1)*100.0;
                                else if( courses.length!=1)
                                return completedcourse*100.0;
                                }else {
                                  return 0.0;
                                }
                               
                                   })(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                       color: Colors.green,
                      ),
                    ),
                      ]),
                        
                      ),ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  var course = courses[index];
            
                  Course? coursedes;
            
                              for (Course c in _courses) {
                                if (c.id == course.courseid) {
                                  coursedes = c;
                                  break;
                                }
                              }
                  return GestureDetector(
                   onTap: () {    if(course.courseprerequisite!='NULL'){ 
                   showMLPopup(
                                    context,
                                    course.courseid ?? '',
                                    course.name?? '',
                                    course.progress.toString() ?? '',
                                    coursedes?.courseDescription ?? '',
                                    coursedes?.courseStartDate ?? '',
                                    coursedes?.courseEndDate ?? '',
                                    coursedes?.courseVideoUrl ?? '',
                                    coursedes?.courseDuration ?? '',
                                  );}
                                      else {
                                    Showerrordialog(context,'This Course is Locked!!','Previous course in the Learning Path should be completed to access this course..!!');
                                  }
                   },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Stack(
                        children:[ 
                          Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                      child:Column(
                        children: [
                       if(course.courseprerequisite=='NULL')
                            Icon(Icons.lock, color: Theme.of(context).primaryColor,size: 18,),
                       if(course.courseprerequisite!='NULL')
                        Icon(Icons.circle, color: Colors.green,size: 18,),
                        ]
                      ),
                          ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            boxShadow: [
                            
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                               
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  child: 
                                                          Image.network(
                                                            
                                                                '${course.imageUrl}?token=${widget.token}',
                                                                height: 40,
                                                                width: 80,
                                                                fit: BoxFit.fill,
                                                                errorBuilder: (context, error, stackTrace) {
                                                                  return Image.asset(
                                                                    'assets/images/coursedefaultimg.jpg',
                                        height: 40,
                                                                width: 80,
                                                                    fit: BoxFit.fill,
                                                                  );
                                                                },
                                                              ),
                                                          ),
                                    ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.name,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 15,
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF3ACBE8).withOpacity(0.3),
                                                    Color(0xFF0D85D8).withOpacity(0.3),
                                                    Color(0xFF0041C7).withOpacity(0.3),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if(course.progress>7)
                                            Container(
                                              height: 15,
                                              width: MediaQuery.of(context).size.width * 0.5 * (course.progress / 100),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF3ACBE8),
                                                    Color(0xFF0D85D8),
                                                    Color(0xFF0041C7),
                                                  ],
                                                  stops: [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                            if (course.progress < 7 && course.progress>0)
                                              Positioned(
                                                left: MediaQuery.of(context).size.width * 0.55 *0.07-20,
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF3ACBE8),
                                                        Color(0xFF0D85D8),
                                                        Color(0xFF0041C7),
                                                      ],
                                                      stops: [0.0, 0.5, 1.0],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        blurRadius: 5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (course.progress >= 7)
                                              Positioned(
                                                left: MediaQuery.of(context).size.width * 0.51* (course.progress / 100) - 20,
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFF3ACBE8),
                                                        Color(0xFF0D85D8),
                                                        Color(0xFF0041C7),
                                                      ],
                                                      stops: [0.0, 0.5, 1.0],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        blurRadius: 5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '${course.progress.toInt()}%',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
  void showMLPopup(BuildContext context, String courseId, String course_name, String Cprogress, String Cdiscrpition,
      String courseStartDate, String courseEndDate, String course_videourl, String courseDuration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MLPopup(
            token: widget.token,
            course_id: courseId,
            course_name: course_name,
            Cprogress: Cprogress,
            Cdiscrpition: Cdiscrpition,
            courseStartDate: courseStartDate,
            courseEndDate: courseEndDate,
            course_videourl: course_videourl,
            courseDuration: courseDuration); // Create an instance of MLPopup without passing context
      },
    );
  }
}
