import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ContinueWatchingScreen extends StatefulWidget {
  final String token;



   ContinueWatchingScreen({Key? key, required this.token, })
      : super(key: key);

  @override
  _ContinueWatchingScreenState createState() => _ContinueWatchingScreenState();
}

class _ContinueWatchingScreenState extends State<ContinueWatchingScreen> {
     List<CourseData> courses=[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
_fetchCourses();
   
  
  }

  Future<void> _fetchCourses() async {
    try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('homepageData')) {
      final homepageData = prefs.getString('homepageData');
      final decodedData = jsonDecode(homepageData!);
      final List<dynamic> courseList = decodedData['courses'];
      final List<CourseData> courses1 = courseList.map((course) => CourseData.fromJson(course)).toList();
     setState(() {
       courses=courses1;
     });
    }else{
      _fetchHomePageData();
    }} catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle errors appropriately
      print('Failed to load courses: $e');
    }
  }
   Future<void> _fetchHomePageData() async {
    try {
      final HomePageData response = await HomePageService.fetchHomePageData(widget.token);
      final List<CourseData> courses1 = response.allCourses;
      setState(() {
        courses = courses1;
        isLoading = false;
      });

      final encodedData = jsonEncode({'courses': courses});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('homepageData', encodedData);
    } catch (e) {
      print('Error fetching homepage data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Learning'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
  itemCount: courses.isEmpty ? 10 : courses.length, // Use 5 shimmer items if courses list is empty
  itemBuilder: (context, index) {
    if (courses.isEmpty||isLoading) {
     
      return _buildShimmerItem();
    }
    
    final CourseData course = courses[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Container(
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: Container(
            width: 100.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              course.getImageUrlWithToken(widget.token),
              fit: BoxFit.cover,
              width: double.infinity,
              // height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                // Return a default image when loading fails
                return Image.asset(
                  'assets/images/coursedefaultimg.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                //  height: double.infinity,
                );
              },
            ),
          ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                'Start Date: ${course.courseStartDate}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                'End Date: ${course.courseEndDate}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getStatusText(course.courseProgress),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(course.courseProgress),
                ),
              ),
              SizedBox(height: 6), // Add some space between the text and the progress indicator
              SizedBox(
                width: 32, // Set the width of the circular progress indicator
                height: 32, // Set the height of the circular progress indicator
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: course.courseProgress / 100,
                      strokeWidth: 3,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatusColor(course.courseProgress),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${course.courseProgress}%',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
),
 bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0, token: widget.token),
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
