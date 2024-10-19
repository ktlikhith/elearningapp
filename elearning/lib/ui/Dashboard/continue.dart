import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomDashboardWidget extends StatefulWidget {
  final String token;

  CustomDashboardWidget({Key? key, required this.token}) : super(key: key);

  @override
  _CustomDashboardWidgetState createState() => _CustomDashboardWidgetState();
}

class _CustomDashboardWidgetState extends State<CustomDashboardWidget> {
  List<CourseData> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndLoadData();
  }

  Future<void> _checkAndLoadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('homepageData')) {
      final homepageData = prefs.getString('homepageData');
      final decodedData = jsonDecode(homepageData!);
      final List<dynamic> courseList = decodedData['courses'];
      final List<CourseData> courses = courseList.map((course) => CourseData.fromJson(course)).toList();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } else {
      _fetchHomePageData();
    }
  }

  Future<void> _fetchHomePageData() async {
    try {
      final HomePageData response = await HomePageService.fetchHomePageData(widget.token);
      final List<CourseData> courses = response.allCourses;
      setState(() {
        _courses = courses;
        _isLoading = false;
      });

      final encodedData = jsonEncode({'courses': courses});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('homepageData', encodedData);
    } catch (e) {
      print('Error fetching homepage data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildShimmerItem() {
    return SizedBox(
      width: 240,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget _buildSection(BuildContext context, CourseData course) {
   double cardHeight = MediaQuery.of(context).size.height*0.25; // Define a constant height for the card
   double cardWidth = MediaQuery.of(context).size.width*0.8; // Define a constant width for the card
  const double titleMaxHeight = 36; // Maximum height for the title text (2 lines)

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
       width: MediaQuery.of(context).orientation==Orientation.portrait? cardWidth:cardWidth*0.5,
      // height: cardHeight,
      
       // Set the card height to a constant value
      child: Container(
        padding: const EdgeInsets.all(8.0),
      
      //  decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.0),border: Border.all(color:Theme.of(context).primaryColor)),
        
        
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
           
            //border: Border.all(color: Theme.of(context).cardColor,width: 2),
             
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints:  BoxConstraints(minHeight: cardHeight, // Set the minimum height
      maxHeight: double.infinity,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
            
             // BoxDecoration(border: Border.all(color: Colors.black))
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: () => showMLPopup(
                  context,
                  course.id,
                  course.name,
                  course.courseProgress.toString(),
                  course.courseDescription,
                  course.courseStartDate,
                  course.courseEndDate,
                  course.courseVideoUrl,
                  course.courseDuration,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height:MediaQuery.of(context).orientation==Orientation.portrait? cardHeight * 0.6:cardHeight*1.5, // Adjust image height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border:Border.all(color: Theme.of(context).cardColor),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        
                        ),
                       
                      ),
                      child: ClipRRect(
                        
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0),
                          
                          
                        ),
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Image.network(
                            course.getImageUrlWithToken(widget.token),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              // Return a default image when loading fails
                              return Image.asset(
                                'assets/images/coursedefaultimg.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,top: 5,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name,
                           //'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
                            maxLines: 2,
                            
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                             // height:0.8,
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).highlightColor
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'End Date: ${course.courseEndDate}',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: course.courseProgress / 100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: getProgressBarColor(course.courseProgress),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${course.courseProgress}%',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


  Color getProgressBarColor(int progress) {
    if (progress >= 0 && progress <= 35) {
      return Colors.red;
    } else if (progress > 80) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [ SizedBox(width: 10,),SizedBox(
                                width: 30,
                                height:30,
                                child: Image.asset(
                                'assets/upcoming and continue learning (1)/continue learning/video-lesson.png',
                                  fit: BoxFit.fill,
                                ),
                              ),SizedBox(width: 10,),
                  Text(
                    'Continue Learning',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContinueWatchingScreen(
                      token: widget.token,
                      
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _isLoading
                ? List.generate(
                    5,
                    (index) => _buildShimmerItem(),
                  )
                : _courses.map((course) {
                    return _buildSection(context, course);
                  }).toList(),
          ),
        ),
      ],
    );
  }

  void showMLPopup(
    BuildContext context,
    String courseId,
    String course_name,
    String Cprogress,
    String Cdiscrpition,
    String courseStartDate,
    String courseEndDate,
    String course_videourl,
    String courseDuration,
  ) {
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
          courseDuration: courseDuration,
        );
      },
    );
  }
}
