import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:flutter/material.dart';

class BuildCourseSections extends StatefulWidget {
  final String token;

  const BuildCourseSections({Key? key, required this.token}) : super(key: key);

  @override
  _BuildCourseSectionsState createState() => _BuildCourseSectionsState();
}

class _BuildCourseSectionsState extends State<BuildCourseSections> {
 
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course> _courses = [];
  bool _isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    _fetchCourses(widget.token);
  }

   Future<void> _fetchCourses(String token) async {
    try {
      final List<Course> response = await _apiService.getAllCourses(token);
      if (mounted) {
        setState(() {
          _courses = response;
          _isLoading = false; // Update loading state
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching courses
        : SingleChildScrollView(
            child: Column(
              children: _courses.map((course) => buildCourseContainer(context, course)).toList(),
            ),
          );
  }

  Widget buildCourseContainer(BuildContext context, Course course) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: buildSingleCourseSection(context,course), // Pass course data
  );
}

Widget buildSingleCourseSection(BuildContext context, Course course) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Video section with play button (moved to the top of the container)
      Container(
        width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
        height: MediaQuery.of(context).size.height * 0.3, // 60% of screen height
        // Placeholder color for the video
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0, // Border width
          ),
    borderRadius: BorderRadius.circular(8.0),
     image: course.courseImg != null && course.courseImg.isNotEmpty
        ? DecorationImage(
            image: NetworkImage(course.courseImg!),
            fit: BoxFit.cover,
          )
        : DecorationImage(
            image: AssetImage('assets/placeholder_image.jpg'),
            fit: BoxFit.cover,
          ),
  ),
        
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_circle_filled, size: 40.0, color: Colors.black),
              onPressed: () {
                showMLPopup(context); // Call showMLPopup with the context
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0), // Add spacing between video section and other content
      // Video Title below the video section
      Text(
        course.name, // Use course title dynamically
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8.0), // Add spacing between title and status
      // Status and due date
     
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status', // Replace with actual status title
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 34, 34, 34),
                  ),
                ),
                Text(
                  '10', // Use course status dynamically
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0), // Add spacing between status and due date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date', // Replace with actual due date title
                  style: TextStyle(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 48, 48, 48),
                  ),
                ),
                Text(
                  course.courseEndDate, // Use course due date dynamically
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // Add functionality for download button
              },
            ),
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Add functionality for more button
              },
            ),
          ],
        ),
      
      const SizedBox(height: 8.0), // Add spacing between status and download/more options
    ],
  );
}

void showMLPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MLPopup(); // Create an instance of MLPopup without passing context
    },
  );
}

}