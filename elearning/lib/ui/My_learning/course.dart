import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
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

class BuildCourseSections extends StatefulWidget {
  final String token;
  final String searchQuery;

  const BuildCourseSections({Key? key, required this.token, required this.searchQuery}) : super(key: key);

  @override
  _BuildCourseSectionsState createState() => _BuildCourseSectionsState();
}

class _BuildCourseSectionsState extends State<BuildCourseSections> {
  final CourseReportApiService _apiService = CourseReportApiService();
  List<Course> _courses = [];
  bool _isLoading = true;

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
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }
    @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, _) {
        List<Course> filteredCourses = provider.course?.where((course) {
          return course.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
        }).toList() ?? [];

        return provider.isLoading
            ? _buildShimmerEffect()
            : SingleChildScrollView(
                child: Column(
                  children: filteredCourses
                      .map((course) => buildCourseContainer(context, course))
                      .toList(),
                ),
              );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //    final courseeprovider = Provider.of<CourseProvider>(context, listen: false);
  //   List<Course> filteredCourses = _courses.where((course) {
  //     return course.name.toLowerCase().contains(widget.searchQuery.toLowerCase());
  //   }).toList();

  //   return  _isLoading
  //       ? _buildShimmerEffect()
  //       :  ChangeNotifierProvider(
  //     create: (_) => CourseProvider(),
  //     child: 
    
  //       SingleChildScrollView(
  //           child: Column(
  //             children: filteredCourses.map((course) => buildCourseContainer(context, course)).toList(),
  //           ),
  //         ),
  //       );
  // }

  Widget _buildShimmerEffect() {
    return 
    Consumer<CourseProvider>(
            builder: (context, provider, _) {
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
    );
  }

  Widget buildCourseContainer(BuildContext context, Course course) {
    return
    Consumer<CourseProvider>(
            builder: (context, CourseProvider, _) { 
              return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      //padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        // border: Border.all(color: Theme.of(context).primaryColor,width: 1.5),
       // color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: buildSingleCourseSection(context, course),
    );
    
  }
    );
  }

  Widget buildSingleCourseSection(BuildContext context, Course course) {
    String courseId = course.id;
    String courseName = course.name;
    String progress = course.courseProgress.toString();
    String description = course.courseDescription;
    String startDate = course.courseStartDate;
    String endDate = course.courseEndDate;
    String videoUrl = course.courseVideoUrl;
    String duration = course.courseDuration;

    return  Consumer<CourseProvider>(
            builder: (context, CourseProvider, _) { 
              return GestureDetector(
      onTap: () => showMLPopup(
        context,
        courseId,
        courseName,
        progress,
        description,
        startDate,
        endDate,
        videoUrl,
        duration,
      ),
      child: Container(
        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).cardColor,
              ),

       
        
        child: Column(
          
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
               width: MediaQuery.of(context).size.width * 1.0,
               height: MediaQuery.of(context).size.height * 0.165,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
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
            ),
            const SizedBox(height: 6.0),
             Padding(
                    padding: const EdgeInsets.only(left: 10.0,top: 5,right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
            Text(
              course.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).highlightColor
              ),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                              StreamBuilder<int>(
                                stream: CourseReportApiService().getCprogress(course.id,widget.token),
                                builder: (context, snapshot) {

                                  return Container(
                                    height: 8.0,
                                    width: snapshot.hasData?100.0*snapshot.data!/100:
                                     100.0 * course.courseProgress / 100,
                                    decoration: BoxDecoration(
                                      color: getProgressBarColor(course.courseProgress),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        
                        StreamBuilder<int>(
                          
                           stream: CourseReportApiService().getCprogress(course.id,widget.token), 
                          builder: (context, snapshot) {
                            return Text(snapshot.hasData?'${snapshot.data!}%':
                              '${course.courseProgress}%',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                Column(
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
                ),
              ],
            ),
            const SizedBox(height: 6.0),
                      ],
                      ),
                      ),
          ],
        ),
      ),
    );
    
  }
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
  

  CourseProvider() {
  String? token;
    fetchData(token);
  }

  Future<void> fetchData(token) async {
    try {
      if(token!=null){
          final List<Course> response = await _apiService.fetchCourses(token);
     
      course = response;
      }
     
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
       print(course);
      notifyListeners();
    }
  }
}

