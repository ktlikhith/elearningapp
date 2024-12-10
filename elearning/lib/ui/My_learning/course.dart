import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/utilites/networkerrormsg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// class BuildCourseSections extends StatefulWidget {
//   final String token;

//   const BuildCourseSections({Key? key, required this.token}) : super(key: key);

//   @override
//   _BuildCourseSectionsState createState() => _BuildCourseSectionsState();
// }

// class _BuildCourseSectionsState extends State<BuildCourseSections> {
//   final CourseReportApiService _apiService = CourseReportApiService();
//   List<Course> _courses = [];

//   bool _isLoading = true; // Flag to track loading state

//   @override
//   void initState() {
//     super.initState();
//     _fetchCourses(widget.token);
//   }

//   Future<void> _fetchCourses(String token) async {
//     try {
//       final List<Course> response = await _apiService.fetchCourses(token);
//       if (mounted) {
//         setState(() {
//           _courses = response;
          
//           _isLoading = false; // Update loading state
//         });
//       }
//     } catch (e) {
//       print('Error fetching courses: $e');
//       // Handle error here
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? _buildShimmerEffect() // Show shimmer effect while loading
//         : SingleChildScrollView(
//             child: Column(
//               children: _courses.map((course) => buildCourseContainer(context, course)).toList(),
//             ),
//           );
//   }

//   Widget _buildShimmerEffect() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 3, // Show 3 dummy containers while loading
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 16.0),
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.0),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2), // changes position of shadow
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 200, // Adjust height as needed
//                   color: Colors.grey, // Placeholder color for the video
//                 ),
//                 const SizedBox(height: 16.0), // Add spacing between video section and other content
//                 Container(
//                   width: double.infinity,
//                   height: 20.0,
//                   color: Colors.grey, // Placeholder color for title
//                 ),
//                 const SizedBox(height: 8.0), // Add spacing between title and status
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 100.0,
//                       height: 12.0,
//                       color: Colors.grey, // Placeholder color for status
//                     ),
//                     const SizedBox(width: 16.0), // Add spacing between status and due date
//                     Container(
//                       width: 80.0,
//                       height: 12.0,
//                       color: Colors.grey, // Placeholder color for due date
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0), // Add spacing between status and download/more options
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildCourseContainer(BuildContext context, Course course) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 12),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: Color.fromARGB(255, 227, 241, 240),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 0,
//             blurRadius: 2,
//             offset: const Offset(0, 2), // changes position of shadow
//           ),
//         ],
//       ),
//       child: buildSingleCourseSection(context, course), // Pass course data
//     );
//   }

// Widget buildSingleCourseSection(BuildContext context, Course course) {
//   String course_id=course.id;
//   String course_name = course.name;
//   String Cprogress = course.courseProgress.toString();
//   String Cdiscrpition = course.courseDescription;
//   String courseStartDate = course.courseStartDate;
//   String courseEndDate = course.courseEndDate;
//   String course_videourl = course.courseVideoUrl;
//   String courseDuration = course.courseDuration;

//   return GestureDetector(
    
//     onTap: () => showMLPopup(
//       context,
//       course_id,
//       course_name,
//       Cprogress,
//       Cdiscrpition,
//       courseStartDate,
//       courseEndDate,
//       course_videourl,
//       courseDuration,
//     ),
//     child: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Container(
//       width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
//       height: MediaQuery.of(context).size.height * 0.22, // 22% of screen height
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//            child: ClipRRect(
//             borderRadius: BorderRadius.circular(9.0),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Image.network(
//             course.getImageUrlWithToken(widget.token),
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//             errorBuilder: (context, error, stackTrace) {
//               return Image.asset(
//                 'assets/images/coursedefaultimg.jpg',
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               );
//             },
//           ),
//         ],
//       ),
//            ),
//     ),
//     const SizedBox(height: 6.0), // Add spacing between video section and other content
//     Text(
//       course.name, // Use course title dynamically
//       style: TextStyle(
//         fontSize: 18.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     const SizedBox(height: 6.0), // Add spacing between title and status
//     Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Status', // Replace with actual status title
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Color.fromARGB(255, 34, 34, 34),
//               ),
//             ),
//             const SizedBox(height: 6.0),
//             Row(
//               children: [
//                 SizedBox(
//                   height: 8.0,
//                   width: 100.0, // Adjusted width for the progress bar
//                   child: Stack(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: 8.0,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       Container(
//                         height: 8.0,
//                         width: 100.0 * course.courseProgress / 100, // Dynamic width based on progress
//                         decoration: BoxDecoration(
//                           color: getProgressBarColor(course.courseProgress), // Change color based on progress
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8.0), // Add some space between the progress bar and the text
//                 Text(
//                   '${course.courseProgress}%', // Display the progress percentage
//                   style: TextStyle(
//                     fontSize: 12.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(width: 16.0), // Add spacing between status and due date
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Due Date', // Replace with actual due date title
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: const Color.fromARGB(255, 48, 48, 48),
//               ),
//             ),
//             Text(
//               course.courseEndDate, // Use course due date dynamically
//               style: TextStyle(
//                 fontSize: 14.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//     const SizedBox(height: 6.0), // Add spacing between status and download/more options
//   ],
// ),

//   );
// }


//   Color getProgressBarColor(int progress) {
//     if (progress >= 0 && progress <= 35) {
//       return Colors.red; // Color for not started
//     } else if (progress >80) {
//       return Colors.green; // Color for completed
//     } else {
//       return Colors.orange; // Color for in progress
//     }
//   }

//   void showMLPopup(BuildContext context, String courseId, String course_name, String Cprogress, String Cdiscrpition,
//       String courseStartDate, String courseEndDate, String course_videourl, String courseDuration) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MLPopup(
//             token: widget.token,
//             course_id: courseId,
//             course_name: course_name,
//             Cprogress: Cprogress,
//             Cdiscrpition: Cdiscrpition,
//             courseStartDate: courseStartDate,
//             courseEndDate: courseEndDate,
//             course_videourl: course_videourl,
//             courseDuration: courseDuration); // Create an instance of MLPopup without passing context
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BuildCourseSections extends StatefulWidget {
  final String token;
  final String searchQuery;
  final bool reportprovider;
 

  const BuildCourseSections({Key? key, required this.token, required this.searchQuery,required this.reportprovider}) : super(key: key);

  @override
  _BuildCourseSectionsState createState() => _BuildCourseSectionsState();
}
class _BuildCourseSectionsState extends State<BuildCourseSections> {
  late CourseProvider provider;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    print("Initializing BuildCourseSections...");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isFetching) {
      provider = Provider.of<CourseProvider>(context, listen: false);
      provider.setTokenAndFetch(widget.token);
      _isFetching = true; // Ensure fetch is done only once
    }
  }

  @override
  void dispose() {
    // Mark that we are no longer interested in fetching new data
    _isFetching = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageProvider>(
        builder: (context, provider, child) {
        // If the search query is empty, display all courses
       List<CourseData> filteredCourses = widget.searchQuery.isEmpty
          ? provider.allCourses // Use the provider's full list of courses
          : provider.allCourses.where((course) {
              // Filter courses based on the search query (case insensitive)
              return course.name
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase());
            }).toList();

        return provider.isLoading ||provider.error!=null
            ? _buildShimmerEffect()
          // Show shimmer while loading
            : filteredCourses.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: filteredCourses
                          .map((course) => buildCourseContainer(context, course, provider))
                          .toList(),
                    ),
                  )
                : Center(child: Text('No courses found.'));  // Handle empty list case
      },
    );
  }




  Widget _buildShimmerEffect() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.0,
                      height: 12.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 16.0),
                    Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildCourseContainer(BuildContext context, CourseData course, HomePageProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: buildSingleCourseSection(context, course, provider),
    );
  }

  Widget buildSingleCourseSection(BuildContext context, CourseData course, HomePageProvider provider) {
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCourseImage(context, course),
            const SizedBox(height: 6.0),
            buildCourseDetails(context, course, provider),
          ],
        ),
      ),
    );
  }

  Widget buildCourseImage(BuildContext context, CourseData course) {
    return Container(
      width: MediaQuery.of(context).size.width * 1.0,
      height:MediaQuery.of(context).orientation!=Orientation.landscape? MediaQuery.of(context).size.height * 0.165:MediaQuery.of(context).size.height* .5,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Image.network(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCourseDetails(BuildContext context, CourseData course, HomePageProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 5, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).highlightColor,
            ),
          ),
          const SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildProgressSection(context, course),
              buildDueDateSection(context, course),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ),
    );
  }

  Widget buildProgressSection(BuildContext context, CourseData course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        const SizedBox(height: 6.0),
        Row(
          children: [
            SizedBox(
              height: 8.0,
              width: 100.0,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Container(
                    height: 8.0,
                    width: 100.0 * course.courseProgress / 100,
                    decoration: BoxDecoration(
                      color: getProgressBarColor(course.courseProgress),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '${course.courseProgress}%',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDueDateSection(BuildContext context, CourseData course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: TextStyle(
            fontSize: 14.0,
            color: Theme.of(context).hintColor,
          ),
        ),
        Text(
          course.courseEndDate,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).highlightColor,
          ),
        ),
      ],
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

  void showMLPopup(
    BuildContext context,
    String courseId,
    String courseName,
    String progress,
    String description,
    String startDate,
    String endDate,
    String videoUrl,
    String duration,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MLPopup(
          token: widget.token,
          course_id: courseId,
          course_name: courseName,
          Cprogress: progress,
          Cdiscrpition: description,
          courseStartDate: startDate,
          courseEndDate: endDate,
          course_videourl: videoUrl,
          courseDuration: duration,
        );
      },
    );
  }
}
class CourseProvider with ChangeNotifier {
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course>? course;
  bool isLoading = true;

  // Remove the token from the constructor
  CourseProvider() {
    // No need to fetch data here; we'll do it after setting the token.
  }

  // Method to set the token and fetch courses
  Future<void> setTokenAndFetch(String token) async {
    await fetchData(token);
  }

  Future<void> fetchData(String token) async {
    try {
      isLoading = true;  // Set loading to true while fetching data
      notifyListeners(); // Notify listeners about loading state
      final List<Course> response = await _apiService.fetchCourses(token);
      course = response;
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false; // Set loading to false after fetching
      notifyListeners(); // Notify listeners after fetching data
    }
  }
}
