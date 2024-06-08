import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
  bool _isContentVisible = false; // State variable to track visibility of content

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: learningPathData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingSkeleton();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!['learningpathdetail'].isEmpty) {
            return Center(
              child: Text('No Data to Show'),
            );
          } else {
            final learningPathDetail = snapshot.data!['learningpathdetail'][0];
            final List<dynamic> courseProgress = snapshot.data!['learningpath_progress'];
            return _buildLearningPathPage(context, learningPathDetail, courseProgress, _courses);
          }
        },
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

  Widget _buildLearningPathPage(BuildContext context, Map<String, dynamic> learningPathDetail, List<dynamic> courseProgress, List<Course> courses) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    '${Constants.baseUrl}${learningPathDetail['learningpathimage']}',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Return a default image when loading fails
                      return Image.asset(
                        'assets/images/coursedefaultimg.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          learningPathDetail['learningpathname'],
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          removeHtmlTags(learningPathDetail['discriotion']),
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 8.0),
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
                                  'Duration: ${learningPathDetail['duration']}',
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
                                'No.Courses: ${learningPathDetail['nocourses']}',
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
                          percent: learningPathDetail['progress'] / 100,
                          backgroundColor: Color.fromARGB(255, 204, 205, 205),
                          progressColor: getProgressBarColor(learningPathDetail['progress']),
                          center: Text(
                            "${learningPathDetail['progress']}%",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isContentVisible = !_isContentVisible;
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
                          _isContentVisible ? Icons.expand_less : Icons.expand_more,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  _isContentVisible
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: courseProgress.length,
                          separatorBuilder: (context, index) => SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            final course = courseProgress[index];
                            Course? coursedes;

                            for (Course c in _courses) {
                              if (c.id == course['courseid']) {
                                coursedes = c;
                                break;
                              }
                            }
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: InkWell(
                                onTap: () => showMLPopup(
                                  context,
                                  course['courseid'] ?? '',
                                  course['coursename'] ?? '',
                                  course['courseprogressbar'].toString() ?? '',
                                  coursedes?.courseDescription ?? '',
                                  coursedes?.courseStartDate ?? '',
                                  coursedes?.courseEndDate ?? '',
                                  coursedes?.courseVideoUrl ?? '',
                                  coursedes?.courseDuration ?? '',
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          '${course['courseimg']}?token=${widget.token}',
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            // Return a default image when loading fails
                                            return Image.asset(
                                              'assets/images/coursedefaultimg.jpg',
                                              height: 200,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        removeHtmlTags(course['coursename']),
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        removeHtmlTags(course['coursedec']),
                                        style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
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
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
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

  // Function to remove HTML tags from strings
  String removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}
