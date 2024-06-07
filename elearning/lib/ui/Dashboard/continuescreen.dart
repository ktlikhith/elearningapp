import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContinueWatchingScreen extends StatefulWidget {
  final String token;
  final List<CourseData> initialCourses;

  const ContinueWatchingScreen({Key? key, required this.token, required this.initialCourses})
      : super(key: key);

  @override
  _ContinueWatchingScreenState createState() => _ContinueWatchingScreenState();
}

class _ContinueWatchingScreenState extends State<ContinueWatchingScreen> {
  late List<CourseData> courses;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    courses = widget.initialCourses;
    if (courses.isEmpty) {
      _fetchCourses();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCourses() async {
    try {
      // Simulating network request
      await Future.delayed(Duration(seconds: 2));
      // Fetch courses here
      // courses = await fetchCourses(widget.token);

      setState(() {
        courses = []; // Assign the fetched courses here
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors appropriately
      print('Failed to load courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Watching'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: isLoading ? _buildShimmerList() : _buildCourseList(),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildShimmerItem();
      },
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final CourseData course = courses[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Color.fromARGB(255, 11, 11, 11)!),
          ),
          child: Container(
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: Container(
                width: 100.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ),
                child: CachedNetworkImage(
                  imageUrl: course.getImageUrlWithToken(widget.token),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/coursedefaultimg.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Start Date: ${course.courseStartDate}',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'End Date: ${course.courseEndDate}',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Text(
                _getStatusText(course.courseProgress),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(course.courseProgress),
                ),
              ),
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[400]!),
        ),
        child: Container(
          color: Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300],
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300],
                ),
              ],
            ),
            trailing: Container(
              width: 60.0,
              height: 10.0,
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(int progress) {
    if (progress == 0) {
      return 'Not Started';
    } else if (progress == 100) {
      return 'Completed';
    } else {
      return 'In Progress';
    }
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

  void showMLPopup(
    BuildContext context,
    String courseId,
    String courseName,
    String courseProgress,
    String courseDescription,
    String courseStartDate,
    String courseEndDate,
    String courseVideoUrl,
    String courseDuration,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MLPopup(
          token: widget.token,
          course_id: courseId,
          course_name: courseName,
          Cprogress: courseProgress,
          Cdiscrpition: courseDescription,
          courseStartDate: courseStartDate,
          courseEndDate: courseEndDate,
          course_videourl: courseVideoUrl,
          courseDuration: courseDuration,
        );
      },
    );
  }
}
