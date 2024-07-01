// import 'dart:async';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/report_service.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter/widgets.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:shimmer/shimmer.dart';

// class ReportPage extends StatefulWidget {
//   final String token;

//   const ReportPage({Key? key, required this.token}) : super(key: key);

//   @override
//   _ReportPageState createState() => _ReportPageState();
// }

// class _ReportPageState extends State<ReportPage> {
//   final ReportService reportService = ReportService();

//   Report? reportData; // Store fetched report data

//   // Fetch report data from the API
//   Future<void> fetchData(String token) async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final data = await reportService.fetchReport(token);
//       setState(() {
//         reportData = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   bool isLoading = false; // Simulated loading state

//   @override
//   void initState() {
//     super.initState();
//     fetchData(widget.token);
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Report Page'),
//         backgroundColor: Theme.of(context).primaryColor,
//          centerTitle: false,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//              onPressed: () {
//           Navigator.pop(context);
//         },
//           ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Pie Chart
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: _buildPieChart(),
//                     ),
//                     SizedBox(height: 20),
//                     // View More Button
//                     ElevatedButton(
//                       onPressed: () {
//                         // Implement view more functionality
//                       },
//                       child: Text('View More'),
//                     ),
//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// Widget _buildPieChart() {
//   if (isLoading) {
//     // Show shimmer effect while loading data
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         width: double.infinity,
//         height: 200, // Adjust height as needed
//         color: Colors.white, // Placeholder color for shimmer effect
//       ),
//     );
//   } else if (reportData != null) {
//     // Build the actual pie chart when data is available
//     // Map<String, double> dataMap = {
//     //   'Completed': (reportData!.completedActivity.toDouble() ?? '').toDouble(),
//     //   'Not Completed': ((reportData!.totalNoActivity ?? 0) - (reportData!.completedActivity ?? 0)).toDouble(),
//     // };

//     List<Color> colorList = [Colors.blue, Colors.grey[300]!];

//     return AspectRatio(
//       aspectRatio: 1,
//       child: PieChart(
//         dataMap: dataMap,
//         colorList: colorList,
//         chartType: ChartType.disc,
//         centerText: "Activity",
//         legendOptions: LegendOptions(showLegends: true),
//         chartValuesOptions: ChartValuesOptions(
//           showChartValueBackground: true,
//           showChartValues: true,
//           showChartValuesInPercentage: false,
//           showChartValuesOutside: false,
//           decimalPlaces: 0,
//         ),
//       ),
//     );
//   } else {
//     // Placeholder widget if data is not available
//     return Center(
//       child: Text('No data available.'),
//     );
//   }
// }

// }
import 'dart:async';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elearning/services/report_service.dart';

class ReportPage extends StatefulWidget {
  final String token;

  const ReportPage({Key? key, required this.token}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ReportService reportService = ReportService();

  Report? reportData; // Store fetched report data

  bool isLoading = false; // Simulated loading state

  @override
  void initState() {
    super.initState();
    fetchData(widget.token);
  }

  // Fetch report data from the API
  Future<void> fetchData(String token) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await reportService.fetchReport(token);
      setState(() {
        reportData = data;
        print(data);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Report Page'),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(RouterManger.morescreen, arguments: widget.token);
        },
      ),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Good Morning\nMrs. Cabrera",
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildCard(
                        "MY Course Progress",
                        "123 mmHg",
                        "123",
                        () {
                          Navigator.of(context).pushNamed(RouterManger.mycourseprogress, arguments: widget.token);
                        },
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildCard(
                        "Learning Path",
                        "79 mmHg",
                        "79",
                        () {
                          Navigator.of(context).pushNamed(RouterManger.learningprogress, arguments: widget.token);
                        },
                      ),
                      SizedBox(width: 16),
                      _buildCard(
                        "Certification",
                        "122 BPM",
                        "122",
                        () {
                          Navigator.pushNamed(context, '/certification', arguments: widget.token);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    // child: _buildPieChart(),
                  ),
                  SizedBox(height: 20),
                 
                  
                ],
              ),
            ),
          ),
  );
}

Widget _buildCard(String title, String value, String chartLabel, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildChart(chartLabel),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildChart(String label) {
    return Container(
      height: 50,
      child: Center(
        child: Text(
          "Chart: $label",
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  // Widget _buildPieChart() {
  //   if (isLoading) {
  //     return Shimmer.fromColors(
  //       baseColor: Colors.grey[300]!,
  //       highlightColor: Colors.grey[100]!,
  //       child: Container(
  //         width: double.infinity,
  //         height: 200, // Adjust height as needed
  //         color: Colors.white, // Placeholder color for shimmer effect
  //       ),
  //     );
  //   } else if (reportData != null) {
        
  //     List<Color> colorList = [Colors.blue, Colors.grey[300]!];
  //     Map<String, double> dataMap = {
  //       'Completed': reportData!.completedActivity.toDouble(),
  //      // 'Inprogress':reportData!.IN
  //       'Not Completed': (reportData!.totalNoActivity - reportData!.completedActivity).toDouble(),
  //     };

  //     return AspectRatio(
  //       aspectRatio: 1,
  //       child: PieChart(
  //         dataMap: dataMap,
  //         colorList: colorList,
  //         chartType: ChartType.disc,
  //         centerText: "Activity",
  //         legendOptions: LegendOptions(showLegends: true),
  //         chartValuesOptions: ChartValuesOptions(
  //           showChartValueBackground: true,
  //           showChartValues: true,
  //           showChartValuesInPercentage: false,
  //           showChartValuesOutside: false,
  //           decimalPlaces: 0,
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Center(
  //       child: Text('No data available.'),
  //     );
  //   }
  // }
}
