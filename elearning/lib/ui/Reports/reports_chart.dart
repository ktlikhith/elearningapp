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