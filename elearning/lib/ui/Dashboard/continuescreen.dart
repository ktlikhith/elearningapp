import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/material.dart';

class ContinueWatchingScreen extends StatelessWidget {
  final String token;
  final List<CourseData> courses;

  const ContinueWatchingScreen({Key? key, required this.token, required this.courses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Watching'),
         centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
          },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final CourseData course = courses[index];
          return Card(
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
                    image: DecorationImage(
                      image: NetworkImage(course.getImageUrlWithToken(token)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name),
                    Text('Start Date: ${course.courseStartDate}'),
                    Text('End Date: ${course.courseEndDate}'),
                  ],
                ),
                trailing: Text(
                  _getStatusText(course.courseProgress),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(course.courseProgress),
                  ),
                ),
                onTap: () {
                  // Navigate to course details screen
                },
              ),
            ),
          );
        },
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
