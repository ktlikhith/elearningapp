import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
      final List<Course> response = await _apiService.fetchCourses(token);
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
        ? _buildShimmerEffect() // Show shimmer effect while loading
        : SingleChildScrollView(
            child: Column(
              children: _courses.map((course) => buildCourseContainer(context, course)).toList(),
            ),
          );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3, // Show 3 dummy containers while loading
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200, // Adjust height as needed
                  color: Colors.grey, // Placeholder color for the video
                ),
                const SizedBox(height: 16.0), // Add spacing between video section and other content
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.grey, // Placeholder color for title
                ),
                const SizedBox(height: 8.0), // Add spacing between title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.0,
                      height: 12.0,
                      color: Colors.grey, // Placeholder color for status
                    ),
                    const SizedBox(width: 16.0), // Add spacing between status and due date
                    Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors.grey, // Placeholder color for due date
                    ),
                  ],
                ),
                const SizedBox(height: 8.0), // Add spacing between status and download/more options
              ],
            ),
          ),
        );
      },
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
      child: buildSingleCourseSection(context, course), // Pass course data
    );
  }

  Widget buildSingleCourseSection(BuildContext context, Course course) {
    String course_id = course.getCourseIDWithToken(widget.token);
    String course_name = course.getcoursenameWithToken(widget.token);
    String Cprogress = course.getcourseProgressWithToken(widget.token);
    String Cdiscrpition = course.getcourseDescriptionWithToken(widget.token);
    String courseStartDate = course.getcourseStartDateWithToken(widget.token);
    String courseEndDate = course.getcourseEndDateWithToken(widget.token);
    String course_videourl = course.getcourseVideoUrlWithToken(widget.token);
    String courseDuration = course.getcourseDurationWithToken(widget.token);

    return GestureDetector(
      onTap: () => showMLPopup(
        context,
        course_id,
        course_name,
        Cprogress,
        Cdiscrpition,
        courseStartDate,
        courseEndDate,
        course_videourl,
        courseDuration,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
            height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  course.getImageUrlWithToken(widget.token),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/coursedefaultimg.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0), // Add spacing between video section and other content
          Text(
            course.name, // Use course title dynamically
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0), // Add spacing between title and status
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
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 8.0,
                    width: 140.0, // Increased width for the progress bar
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        Container(
                          height: 20.0,
                          width: 140.0 *                          course.courseProgress / 100, // Dynamic width based on progress
                          decoration: BoxDecoration(
                            color: getProgressBarColor(course.courseProgress), // Change color based on progress
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ],
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
            ],
          ),
          const SizedBox(height: 8.0), // Add spacing between status and download/more options
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
          context,
          token: widget.token,
          course_id: courseId,
          course_name: course_name,
          Cprogress: Cprogress,
          Cdiscrpition: Cdiscrpition,
          courseStartDate: courseStartDate,
          courseEndDate: courseEndDate,
          course_videourl: course_videourl,
          courseDuration: courseDuration,
        ); // Create an instance of MLPopup without passing context
      },
    );
  }
}

