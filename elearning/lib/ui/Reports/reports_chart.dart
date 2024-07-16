import 'dart:async';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elearning/services/report_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return true;
      },
    child:  Scaffold(
      appBar: AppBar(
         title: Padding(
           padding: const EdgeInsets.only(left: 0.0),
           child: Text('Report Page'),
         ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        automaticallyImplyLeading: false,
         leading: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 0),
            child: SvgPicture.asset('assets/appbarsvg/statistics-svgrepo-com.svg'),
          ),
          leadingWidth: 48,
       
     
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text(
                    //   "Good Morning\nMrs. Cabrera",
                    //   style: GoogleFonts.lato(
                    //     fontSize: 24,r
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        _buildCard(
                          "Course Progress Report",
                          "123 mmHg",
                          "assets/Reportsicon/graphics-graph-svgrepo-com.svg",
                            100,330,
                          () {
                            Navigator.of(context).pushNamed(RouterManger.mycourseprogress, arguments: widget.token);
                          },
                        ),
                        
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildCard(
                          "Learning Path",
                          "79 mmHg",
                          "assets/Reportsicon/undraw_progressive_app_m-9-ms.svg",
                          80,200,
                          () {
                            Navigator.of(context).pushNamed(RouterManger.learningprogress, arguments: widget.token);
                          },
                        ),
                        SizedBox(width: 16),
                        _buildCard(
                          "Certification",
                          "122 BPM",
                          "assets/Reportsicon/undraw_certificate_re_yadi.svg",
                            80,200,
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
             bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 4, token: widget.token),
    ),
      );
  }

  Widget _buildCard(String title, String value, String svgPath,double widthsvg,double heightsvg, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: widthsvg,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).hintColor.withOpacity(0.3),),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(16),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  title,
                  style: GoogleFonts.lato(
                    color:Theme.of(context).cardColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: SvgPicture.asset(
                    svgPath,
                    height: heightsvg, 
                    width: widthsvg,// Adjust size as needed
                  ),
                ),
              
                
              ],
            ),
          ),
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
