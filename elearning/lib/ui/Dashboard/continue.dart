import 'package:elearning/ui/Dashboard/continuescreen.dart';
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
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailsPage(widget.token, course.id,course.name),
                    ),
                  );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(course.getImageUrlWithToken(widget.token)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
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
                            fontSize: 16,
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
                        SizedBox(height: 12),
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
                                color: Colors.green,
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
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change text color to white
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing between text and icon
                      FaIcon(
                        FontAwesomeIcons.angleDoubleRight, // Icon to be used
                        size: 16,
                        color: Colors.white, // Icon color
                      ),
                    ],
                  ),
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
}
