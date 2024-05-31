import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

class CustomDashboardWidget extends StatefulWidget {
  final String token;

  CustomDashboardWidget({Key? key, required this.token}) : super(key: key);

  @override
  _CustomDashboardWidgetState createState() => _CustomDashboardWidgetState();
}

class _CustomDashboardWidgetState extends State<CustomDashboardWidget> {
  List<CourseData> _courses = [];
  bool _isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    _checkAndLoadData(); // Check and load data on widget initialization
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
        _isLoading = false; // Update loading state
      });
    } else {
      _fetchHomePageData(); // Fetch data if not available in SharedPreferences
    }
  }

  Future<void> _fetchHomePageData() async {
    try {
      final HomePageData response = await HomePageService.fetchHomePageData(widget.token);
      final List<CourseData> courses = response.allCourses;
      setState(() {
        _courses = courses;
        _isLoading = false; // Update loading state
      });

      // Save data to SharedPreferences
      final encodedData = jsonEncode({'courses': courses});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('homepageData', encodedData);
    } catch (e) {
      print('Error fetching homepage data: $e');
      // Handle error here
    }
  }

  Widget _buildShimmerItem() {
    return SizedBox(
      width: 300,
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
  const double cardHeight = 300; // Define a constant height for the card
  const double titleMaxHeight = 36; // Maximum height for the title text (2 lines)

  return SizedBox(
    width: 210,
    height: cardHeight, // Set the card height to a constant value
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
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
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate available height for the image
                      double availableHeight = constraints.maxHeight - titleMaxHeight - 80; // Adjust this value as needed
                      return Container(
                        height: availableHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                            course.getImageUrlWithToken(widget.token),
                            fit: BoxFit.fill,
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
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'End Date: ${course.courseEndDate}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: double.infinity,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

 Color getProgressBarColor(int progress) {
    if (progress >= 0 && progress <= 35) {
      return Colors.red; // Color for not started
    } else if (progress >80) {
      return Colors.green; // Color for completed
    } else {
      return Colors.orange; // Color for in progress
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
              child: Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContinueWatchingScreen(token: widget.token, courses: _courses,),
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
                          color: Theme.of(context).secondaryHeaderColor,
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
                    5, // Number of shimmer items
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
