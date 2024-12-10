import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:elearning/utilites/networkerrormsg.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LearningPathDetailScreen extends StatefulWidget {
  final LearningPathDetail learningPath;
  final String token;
  final int index;


  LearningPathDetailScreen({Key? key, required this.token,required this.learningPath,required this.index}) : super(key: key);

  @override
  _LearningPathDetailScreenState createState() => _LearningPathDetailScreenState();
}

class _LearningPathDetailScreenState extends State<LearningPathDetailScreen> {

  
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course> _courses = [];
late Future<Map<String, dynamic>> _learningPathData;
 @override
  void initState() {
    super.initState();
    _learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
    _fetchCourses(widget.token);
  }
  @override
  void dispose(){
    context.read<LearningPathProvider>().fetchLearningPaths();
 super.dispose();
  }
  
 Future<void>  refrseh()async{
  context.read<LearningPathProvider>().fetchLearningPaths();
    setState(() {
       _learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
       _fetchCourses(widget.token);
    });
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
      body: RefreshIndicator(
        onRefresh:refrseh,
        child:
         Consumer<LearningPathProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
              if (provider.error.toString().contains('Connection reset by peer')||provider.error.toString().contains('Connection timed out')||provider.error.toString().contains('ClientException with SocketException: Failed host lookup')) {
  showNetworkError(context);
        return Center(child: CircularProgressIndicator());
  } else{
    // Show the general error message to the user
    SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong please try again.'
)),
    );
    });
        // Handle error state - fallback to default logo
      
  
           return Center(child: CircularProgressIndicator());
  }
          } else if (provider.learningPaths.isEmpty||(provider.learningPaths as List).isEmpty) {
            return Center(child: Text('No learning paths available'));
          } else
              var learningPaths = provider.learningPaths ;
              // List progressList = provider.progressList;
              //  var LPS = LearningPathDetail.fromJson(provider.learningPaths[widget.index], progressList);
               var courses = provider.learningPaths[widget.index].learningpathProgress;
            //List<LearningPathProgress> courses = learningPaths![widget.index]['learningpath_progress'];  
              

          return courses.isEmpty
              ? Center(child: Text('No courses available'))
              : Stack(
                children:[ ListView.builder(
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
                       onTap: () {    if(course.courseprerequisite=='NULL'){ 
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
                                      );}else {
                                         bool  openL=_courses.where((c)=>c.id==course.courseprerequisite).any((c1)=>c1.courseProgress==100);
                                         if(openL==true){
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
                                      );
                                         }
                                      
                                          else {
                                        Showerrordialog(context,'This Course is Locked!!','Previous course(s) in this Learning Path should be completed!!!...');
                                      }
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
                           if(course.courseprerequisite=='NULL'&&course.progress<1||_courses.where((c)=>c.id==course.courseprerequisite).any((c1)=>c1.courseProgress==100)==true&&course.courseprerequisite!='NULL'&&course.progress<1)
                            Icon(FontAwesomeIcons.unlockKeyhole, color: Theme.of(context).cardColor,size: 15,),
                               if(course.progress==100&&course.courseprerequisite=='NULL'||_courses.where((c)=>c.id==course.courseprerequisite).any((c1)=>c1.courseProgress==100)==true&&course.progress==100)
                            Icon(Icons.circle, color:Theme.of(context).cardColor,size: 18,),
                            if(course.progress<100&&course.progress>0)
                             Icon(Icons.circle, color:Colors.orange,size: 18,),
                             if(_courses.where((c)=>c.id==course.courseprerequisite).any((c1)=>c1.courseProgress==100)!=true&&course.courseprerequisite!='NULL')
                             Icon(Icons.lock_rounded, color: Theme.of(context).cardColor,size: 18,),
                             
                              
                         
                         
                           
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
                                                              Container(
                                                                color: Colors.white,
                                                                child: Image.network(
                                                                  
                                                                      '${course.imageUrl}?token=${widget.token}',
                                                                      height: 40,
                                                                      width: MediaQuery.of(context).size.width*0.2,
                                                                      fit: BoxFit.fill,
                                                                    
                                                                      errorBuilder: (context, error, stackTrace) {
                                                                        return Image.asset(
                                                                          'assets/images/coursedefaultimg.jpg',
                                                                      height: 40,
                                                                     width: MediaQuery.of(context).size.width*0.2,
                                                                          fit: BoxFit.fill,
                                                                        );
                                                                      },
                                                                    ),
                                                              ),
                                                              ),
                                        ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.45,
                                          child: Text(
                                            course.name,
                                            maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 15,
                                                  width: MediaQuery.of(context).size.width * 0.45,
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
                                                if(course.progress>7&&course.progress<=100)
                                                Container(
                                                  height: 15,
                                                  width: MediaQuery.of(context).size.width * 0.45 * (course.progress / 100),
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
                                                    left: MediaQuery.of(context).size.width * 0.005,
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
                                                if (course.progress >= 7&&course.progress!=100)
                                                  Positioned(
                                                    left: MediaQuery.of(context).size.width * 0.45* (course.progress / 100)-MediaQuery.of(context).size.width * 0.025,
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
              );
            }
           
        ),
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
    Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 40,
        width: 80,
        color: Colors.white,
      //  margin: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}
