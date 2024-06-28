// import 'dart:convert';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/homepage_service.dart';
// import 'package:flutter/material.dart';

// class Coursereport extends StatefulWidget {
//   final String token;

//   Coursereport({required this.token});

//   @override
//   _CoursePageState createState() => _CoursePageState();
// }

// class _CoursePageState extends State<Coursereport> {
//   late Future<HomePageData> _homePageData;

//   @override
//   void initState() {
//     super.initState();
//     _homePageData = HomePageService.fetchHomePageData(widget.token);
//   }

//   int getCompletedCoursesCount(List<CourseData> courses) {
//     return courses.where((course) => course.courseProgress == 100).length;
//   }

//   int getInProgressCoursesCount(List<CourseData> courses) {
//     return courses.where((course) => course.courseProgress > 0 && course.courseProgress < 100).length;
//   }

//   int getNotStartedCoursesCount(List<CourseData> courses) {
//     return courses.where((course) => course.courseProgress == 0).length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MY Course Progress', style: TextStyle(color: Theme.of(context).highlightColor)),
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () {
//           Navigator.of(context).pushReplacementNamed(RouterManger.morescreen, arguments: widget.token);
//         },
//       ),
//       ),
//       body: FutureBuilder<HomePageData>(
//         future: _homePageData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final data = snapshot.data!;
//             final completedCount = getCompletedCoursesCount(data.allCourses);
//             final inProgressCount = getInProgressCoursesCount(data.allCourses);
//             final notStartedCount = getNotStartedCoursesCount(data.allCourses);

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Completed Courses: $completedCount', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 10),
//                   Text('In-progress Courses: $inProgressCount', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 10),
//                   Text('Not Started Courses: $notStartedCount', style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             );
//           } else {
//             return Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';  // Import the pie_chart package

class Coursereport extends StatefulWidget {
  final String token;

  Coursereport({required this.token});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<Coursereport> {
  late Future<HomePageData> _homePageData;

  @override
  void initState() {
    super.initState();
    _homePageData = HomePageService.fetchHomePageData(widget.token);
  }

  int getCompletedCoursesCount(List<CourseData> courses) {
    return courses.where((course) => course.courseProgress == 100).length;
  }

  int getInProgressCoursesCount(List<CourseData> courses) {
    return courses.where((course) => course.courseProgress > 0 && course.courseProgress < 100).length;
  }

  int getNotStartedCoursesCount(List<CourseData> courses) {
    return courses.where((course) => course.courseProgress == 0).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY Course Progress', style: TextStyle(color: Theme.of(context).highlightColor)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.Report, arguments: widget.token);
          },
        ),
      ),
      body: FutureBuilder<HomePageData>(
        future: _homePageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final completedCount = getCompletedCoursesCount(data.allCourses);
            final inProgressCount = getInProgressCoursesCount(data.allCourses);
            final notStartedCount = getNotStartedCoursesCount(data.allCourses);

            final Map<String, double> dataMap = {
              "Completed": completedCount.toDouble(),
              "In Progress": inProgressCount.toDouble(),
              "Not Started": notStartedCount.toDouble(),
            };

            final List<Color> colorList = [
              const Color.fromARGB(255, 7, 244, 14),  // Completed
              Color.fromARGB(255, 248, 240, 10), // In Progress
              Color.fromARGB(255, 247, 6, 6),    // Not Started
            ];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Course Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  PieChart(
                    
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 35,
                    chartRadius: MediaQuery.of(context).size.width / 2.3,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 35,
                    // centerText: "Courses",
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                       
                      
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                      // Implement view more functionality here
                      Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: widget.token);
                    },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ).copyWith(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'View More',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
                  
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
