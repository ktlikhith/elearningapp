import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/utilites/alertdialog.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LearningPathPage extends StatefulWidget {
  final String token;

  const LearningPathPage({Key? key, required this.token}) : super(key: key);

  @override
  _LearningPathPageState createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  late Future<Map<String, dynamic>> learningPathData;
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course> _courses = [];
  int? _expandedIndex;
    bool openL=false;

  @override
  void initState() {
    super.initState();
    learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Learning Path'),
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
        onRefresh: ()async{
             learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
    _fetchCourses(widget.token);
        },
        child: Consumer<LearningPathProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: _buildLoadingSkeleton());
          } else if (provider.error != null) {
            return Center(child: Text(provider.error!));
          } else if (provider.learningPaths.isEmpty) {
            return Center(child: Text('No learning paths available'));
          }  else {
              final learningPathDetails = provider.learningPaths;
              final  courseProgress = provider.progressList;
        
              return _buildLearningPathPage(context, learningPathDetails, courseProgress, _courses);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 20.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLearningPathPage(BuildContext context, List<dynamic> learningPathDetails, List<dynamic> courseProgress, List<Course> courses) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: learningPathDetails.asMap().entries.map<Widget>((entry) {
          final index = entry.key;
          final learningPathDetail = entry.value;
          final relevantCourses = courseProgress.where((course) => course['learningpath'] == learningPathDetail.id).toList();
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
             // color: Theme.of(context).hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Theme.of(context).cardColor!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        '${Constants.baseUrl}${learningPathDetail.imageUrl}',
                        height: 200,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/coursedefaultimg.jpg',
                            height: 200,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    learningPathDetail.name,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    removeHtmlTags(
                     learningPathDetail.description
                    ),
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.clock,
                          size: 16.0,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Duration: ${learningPathDetail.duration}',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SizedBox(width: 30.0),
                        FaIcon(
                          FontAwesomeIcons.book,
                          size: 16.0,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'No.Courses: ${learningPathDetail.nocourses}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  LinearPercentIndicator(
                    barRadius: Radius.circular(30),
                    lineHeight: 18.0,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    percent: learningPathDetail.progress / 100,
                    backgroundColor: Color.fromARGB(255, 204, 205, 205),
                    progressColor: getProgressBarColor(learningPathDetail.progress),
                    center: Text(
                      "${learningPathDetail.progress}%",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_expandedIndex == index) {
                          _expandedIndex = null; // Collapse if the same card is tapped
                        } else {
                          _expandedIndex = index; // Expand the new card
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Learning Content',
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          _expandedIndex == index ? Icons.expand_less : Icons.expand_more,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _expandedIndex == index
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: relevantCourses.length,
                          separatorBuilder: (context, index) => SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            final course = relevantCourses[index];
                            Course? coursedes;
                          

                            for (Course c in _courses) {
                              if (c.id == course['courseid']) {
                                coursedes = c;
                                break;
                              }
                            }
                            return Container(
                                                            decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!),
                                                            ),
                                                            child: InkWell(
                                                             
                            onTap: () {
                             if(course['courseprerequisite']==null){ 
                              showMLPopup(
                              context,
                              course['courseid'] ?? '',
                              course['coursename'] ?? '',
                              course['courseprogressbar'].toString() ?? '',
                              coursedes?.courseDescription ?? '',
                              coursedes?.courseStartDate ?? '',
                              coursedes?.courseEndDate ?? '',
                              coursedes?.courseVideoUrl ?? '',
                              coursedes?.courseDuration ?? '',
                            );} else {
                          
                                 openL=_courses.where((c)=>c.id==course['courseprerequisite']).any((c1)=>c1.courseProgress==100);
                            
                              
                               if(openL==true){
                                  showMLPopup(
                              context,
                              course['courseid'] ?? '',
                              course['coursename'] ?? '',
                              course['courseprogressbar'].toString() ?? '',
                              coursedes?.courseDescription ?? '',
                              coursedes?.courseStartDate ?? '',
                              coursedes?.courseEndDate ?? '',
                              coursedes?.courseVideoUrl ?? '',
                              coursedes?.courseDuration ?? '',
                            );
                            
                               }else
                              Showerrordialog(context,'This Course is Locked!!',"Previous course(s) in this Learning Path should be completed!!!...");
                            };
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                children:[ Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Center(
                                        child:ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child:Image.network(
                                        '${course['courseimg']}?token=${widget.token}',
                                        height: 200,
                                        width: 350,
                                        fit: BoxFit.fill,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/coursedefaultimg.jpg',
                                            height: 200,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                       ),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      removeHtmlTags(course['coursename']),
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).highlightColor),
                                    ),
                                    SizedBox(height: 8.0),
                                   
                                    Text(
                                    
                                  removeHtmlTags(course['coursedec']),
                                    
                                     
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).hintColor),
                                    ),
                                   
                                    

                                    SizedBox(height: 12.0),
                                    LinearPercentIndicator(
                                      barRadius: Radius.circular(30),
                                      lineHeight: 18.0,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      percent: course['courseprogressbar'] / 100,
                                      backgroundColor: Color.fromARGB(255, 204, 205, 205),
                                      progressColor: getProgressBarColor(course['courseprogressbar']),
                                      center: Text(
                                        "${course['courseprogressbar']}%",
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                if(course['courseprerequisite']!=null)
                                 if(_courses.where((c)=>c.id==course['courseprerequisite']).any((c1)=>c1.courseProgress==100)==false)
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child:
                                    FaIcon(
                                              FontAwesomeIcons.lock,
                                                             size: 40.0,
                                                             color: Colors.black.withOpacity(0.7),
                                                           ),
                                 ),
                                ],
                              ),
                            ),
                                                            ),
                                                          );
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color getProgressBarColor(int progress) {
    if (progress >= 0 && progress <= 35) {
      return Colors.red; // Color for not started
    } else if (progress > 80) {
      return Colors.green; // Color for completed
    } else {
      return Colors.orange; // Color for in progress
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

  String removeHtmlTags(String htmlString) {
    if (htmlString!=''){
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
    }else return 'No data available';
  }
}
