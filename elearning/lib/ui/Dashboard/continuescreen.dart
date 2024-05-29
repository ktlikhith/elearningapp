import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContinueWatchingScreen extends StatelessWidget {
  final String token;
  final List<CourseData> courses;

  const ContinueWatchingScreen({Key? key, required this.token, required this.courses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHorizontal = screenWidth * 0.04;
    final double leadingSize = screenWidth * 0.15;
    final double fontSize = screenWidth * 0.04;
    
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
      body: ListView.builder(
        itemCount: courses.isEmpty ? 5 : courses.length, // Use 5 shimmer items if courses list is empty
        itemBuilder: (context, index) {
          if (courses.isEmpty) {
            return _buildShimmerItem(paddingHorizontal, leadingSize);
          }
          final CourseData course = courses[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: paddingHorizontal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: Container(
              color: Colors.white,
              child: ListTile(
                contentPadding: EdgeInsets.all(screenWidth * 0.02),
                leading: Container(
                  width: leadingSize,
                  height: leadingSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.network(
                    course.getImageUrlWithToken(token),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      // Return a default image when loading fails
                      return Image.asset(
                        'assets/images/coursedefaultimg.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      'Start Date: ${course.courseStartDate}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        fontSize: fontSize * 0.9,
                      ),
                    ),
                    Text(
                      'End Date: ${course.courseEndDate}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        fontSize: fontSize * 0.9,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  _getStatusText(course.courseProgress),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(course.courseProgress),
                    fontSize: fontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailsPage(token, course.id, course.name),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerItem(double paddingHorizontal, double leadingSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: paddingHorizontal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[400]!),
        ),
        child: Container(
          color: Colors.white,
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Container(
              width: leadingSize,
              height: leadingSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[300], // Placeholder color for shimmer effect
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300], // Placeholder color for shimmer effect
                ),
                SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300], // Placeholder color for shimmer effect
                ),
                SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.grey[300], // Placeholder color for shimmer effect
                ),
              ],
            ),
            trailing: Container(
              width: 60.0,
              height: 10.0,
              color: Colors.grey[300], // Placeholder color for shimmer effect
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
}
