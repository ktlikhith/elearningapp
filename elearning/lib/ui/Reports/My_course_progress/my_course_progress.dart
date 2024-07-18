

// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/homepage_service.dart';
// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';  // Import the pie_chart package

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
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.of(context).pushReplacementNamed(RouterManger.Report, arguments: widget.token);
//           },
//         ),
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

//             final Map<String, double> dataMap = {
//               "Completed": completedCount.toDouble(),
//               "In Progress": inProgressCount.toDouble(),
//               "Not Started": notStartedCount.toDouble(),
//             };

//             final List<Color> colorList = [
//               Color.fromARGB(255, 7, 154, 14),  // Completed
//               Color.fromARGB(255, 248, 147, 5), // In Progress
//               Color.fromARGB(255, 241, 25, 25),    // Not Started
//             ];

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text('Course Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 75),
//                   PieChart(
                    
//                     dataMap: dataMap,
//                     animationDuration: Duration(milliseconds: 800),
//                     chartLegendSpacing: 70,
//                     chartRadius: MediaQuery.of(context).size.width / 1.6,
//                     colorList: colorList,
//                     initialAngleInDegree: 0,
//                     chartType: ChartType.ring,
//                     ringStrokeWidth: 60,
//                     // centerText: "Courses",
//                     legendOptions: LegendOptions(
//                       showLegendsInRow: true,
//                       legendPosition: LegendPosition.bottom,
//                       showLegends: true,
                      
//                       legendShape: BoxShape.rectangle,
//                       legendTextStyle: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
                       
                      
//                     ),
//                     chartValuesOptions: ChartValuesOptions(
//                       showChartValueBackground: true,
//                       showChartValues: true,
//                       showChartValuesInPercentage: true,
//                       showChartValuesOutside: false,
//                       decimalPlaces: 0,
//                     ),
//                   ),
//                   SizedBox(height: 90),
//                   Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                
//                 child: ElevatedButton(
//                   onPressed: () {
//                       // Implement view more functionality here
//                       Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: widget.token);
//                     },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     backgroundColor: Theme.of(context).secondaryHeaderColor,
//                   ).copyWith(
//                     overlayColor: MaterialStateProperty.all(Colors.transparent),
//                   ),
                  
//                   child: Text(
//                     'View More',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
                  
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
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';

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

  void _handlePieChartTap(String section) {
    if (section == 'Completed') {
      Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: {
        'token': widget.token,
        'filter': 'completed',
      });
    } else if (section == 'In Progress') {
      Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: {
        'token': widget.token,
        'filter': 'in progress',
      });
    } else if (section == 'Not Started') {
      Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: {
        'token': widget.token,
        'filter': 'not started',
      });
    }
  }

  double calculateAngle(double x, double y, double centerX, double centerY) {
    double dx = x - centerX;
    double dy = y - centerY;
    return (atan2(dy, dx) * 180 / pi + 360) % 360;
  }

  String getSectionByAngle(double angle, List<MapEntry<String, double>> entries) {
    double total = entries.fold(0, (sum, entry) => sum + entry.value);
    double startAngle = 0;
    for (var entry in entries) {
      double sweepAngle = (entry.value / total) * 360;
      if (angle >= startAngle && angle < startAngle + sweepAngle) {
        return entry.key;
      }
      startAngle += sweepAngle;
    }
    return '';
  }

  Widget buildCustomLegend() {
    final List<Color> colorList = [
      Color.fromARGB(255, 7, 154, 14), // Completed
      Color.fromARGB(255, 248, 147, 5), // In Progress
      Color.fromARGB(255, 241, 25, 25), // Not Started
    ];

    final dataMap = {
      'Completed': 0,
      'In Progress': 0,
      'Not Started': 0,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: dataMap.entries.map((entry) {
        final color = colorList[dataMap.keys.toList().indexOf(entry.key)];
        return GestureDetector(
          onTap: () => _handlePieChartTap(entry.key),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: color,
              ),
              SizedBox(width: 8),
              Text(entry.key),
            ],
          ),
        );
      }).toList(),
    );
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
            return Center(child: Text(''));//'Error: ${snapshot.error}
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
              Color.fromARGB(255, 7, 154, 14),  // Completed
              Color.fromARGB(255, 248, 147, 5), // In Progress
              Color.fromARGB(255, 241, 25, 25), // Not Started
            ];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Course Progress', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 75),
                  GestureDetector(
                    onTapUp: (details) {
                      final localPosition = details.localPosition;
                      final centerX = MediaQuery.of(context).size.width / 2;
                      final centerY = MediaQuery.of(context).size.width / 3.2;
                      final angle = calculateAngle(localPosition.dx, localPosition.dy, centerX, centerY);
                      final section = getSectionByAngle(angle, dataMap.entries.toList());
                      if (section.isNotEmpty) {
                        _handlePieChartTap(section);
                      }
                    },
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 70,
                      chartRadius: MediaQuery.of(context).size.width / 1.6,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 60,
                      legendOptions: LegendOptions(
                        showLegends: false, // Disable the default legend
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10),
                    child: buildCustomLegend(),
                  ), // Add the custom legend here
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RouterManger.eachcourseprogress, arguments: {
                          'token': widget.token,
                          'filter': 'all',
                        });
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
