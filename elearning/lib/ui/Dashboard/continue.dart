import 'package:elearning/services/continue_leraning_service.dart';
import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:flutter/material.dart';

class CustomDashboardWidget extends StatefulWidget {
  final String token;

  CustomDashboardWidget({Key? key, required this.token}) : super(key: key);

  @override
  _CustomDashboardWidgetState createState() => _CustomDashboardWidgetState();
}

class _CustomDashboardWidgetState extends State<CustomDashboardWidget> {
  final ContinueService _courseService = ContinueService();
  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses(widget.token);
  }

  Future<void> _fetchCourses(String token) async {
    try {
      final List<Course> response = await _courseService.fetchCourses(token);
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

 
 Widget _buildSection(BuildContext context, Course course) {
  return SizedBox(
    width: 300, // Set a fixed width for all cards
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
              // Handle course tap
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(course.courseImg),
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
  return Visibility(
  visible: _courses.isNotEmpty,
  child: Column(
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
                  builder: (context) => ContinueWatchingScreen(
                    token: widget.token,
                    courses: _courses,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0), // Add left padding here
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
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
          children: _courses.map((course) {
            return _buildSection(context, course);
          }).toList(),
        ),
      ),
    ],
  ),
);
}
}