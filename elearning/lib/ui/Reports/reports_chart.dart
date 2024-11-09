import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elearning/services/report_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer' as developer;

class ReportPage extends StatefulWidget {
  final String token;

  const ReportPage({Key? key, required this.token}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final ReportService reportService = ReportService();
   ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;
 

  Report? reportData; // Store fetched report data

  bool isLoading = false; // Simulated loading state

  @override
  void initState() {
    super.initState();
     initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
      // Lock the screen orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    fetchData(widget.token);
  }
   @override
  void dispose() {
      _connectivitySubscription.cancel();
    // Revert back to the default orientation when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  // Initialize connectivity
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  // Update connectivity status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _dismissNoInternetDialog();
    }
  }

  // Show No Internet Dialog
  void _showNoInternetDialog() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opss No Internet Connection..'),
            content: const Text('Please check your connection. You can try reloading the page or explore the available offline content.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Reload'),
                onPressed: () 
                { fetchData(widget.token);},
                // onPressed: () async {
                //   final result = await _connectivity.checkConnectivity();
                //   _updateConnectionStatus(result);
                // },
              ),
              ElevatedButton(onPressed:(){  Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);}, child:  const Text('Offline Content'),)
              
            ],
          );
        },
      );
    }
  }

  // Dismiss No Internet Dialog
  void _dismissNoInternetDialog() {
    if (isDialogOpen) {
      fetchData(widget.token);
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
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
                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
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
                  
                    Column(
                      children: [
                        _buildCard(
                          "Course Progress Report",
                          "Your Progress at a Glance.",
                          "Track your progress through each course module and see how close you are to completion.",
                          "assets/Reportsicon/reports/flat-interface-with-charts-and-graphs.png",
                          MediaQuery.of(context).size.width*0.9,
                           MediaQuery.of(context).size.width*0.55,
                             MediaQuery.of(context).size.width*0.5,
                              MediaQuery.of(context).size.height*0.38,
                          // 260,180,
                            // 330,280,
                          () {
                            Navigator.of(context).pushNamed(RouterManger.mycourseprogress, arguments: widget.token);
                          },
                        ),
                        
                    //   ],
                    // ),
                    SizedBox(height: 12),
                    // Row(
                    //   children: [
                        _buildCard(
                          "Learning Path",
                          "Your Personalized Learning Path.",
                          "Step-by-step guide through your personalized learning pathway, ensuring you reach your goals.",
                          "assets/Reportsicon/Downloads/office-working-with-a-neural-network01.png",
                            MediaQuery.of(context).size.width*0.9,
                           MediaQuery.of(context).size.width*0.5,
                              MediaQuery.of(context).size.width*0.6,
                              MediaQuery.of(context).size.height*0.16,
                          // 275,250,
                          () {
                            Navigator.of(context).pushNamed(RouterManger.learningprogress, arguments: widget.token);
                          },
                        ),
                       SizedBox(height: 12),
                        _buildCard(
                          "Certification",
                          "Achievements Unlocked.",
                          "A record of your accomplishments, highlighting the certifications that validate your expertise.",
                          "assets/Reportsicon/cert/colors-students-at-graduation-ceremony.png",
                            MediaQuery.of(context).size.width*0.9,
                           MediaQuery.of(context).size.width*0.5,
                              MediaQuery.of(context).size.width*0.55,
                              MediaQuery.of(context).size.height*0.22,
                            // 275,200,
                          () {
                            Navigator.of(context).pushNamed(RouterManger.certificatereport, arguments: widget.token);
                          },
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
            ),
             bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 4, token: widget.token),
    ),
      );
  }

Widget _buildCard(String title, String subtitle, String info, String svgPath,double boxwidth,double boxheight, double widthsvg, double heightsvg, VoidCallback onTap) {
  double topadding=svgPath.contains('assets/Reportsicon/reports/flat-interface-with-charts-and-graphs.png') ? 20.0 : 0.0;
  double leftcert=title.contains('Certification')?20.0:0.0;
  return GestureDetector(
      
    onTap: onTap,
    child: Container(
      height:boxheight,
      width: boxwidth,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          //topLeft: Radius.circular(16),
               // bottomRight: Radius.circular(16),
               topRight: Radius.circular(42),
                bottomLeft: Radius.circular(42)
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            
          
           Padding(
             padding:  EdgeInsets.only(left:leftcert),
             child: Container(
              height: boxheight- MediaQuery.of(context).size.width*0.14,
              width: boxwidth,
                    
               child: Padding(
                 padding:  EdgeInsets.only(top:topadding ),
                 child: Center(
                   child: 
                    
                   svgPath.contains('.png')?
                             
                             
                             Image.asset(
                              svgPath,
                              height: heightsvg,
                              width: widthsvg,
                              alignment:Alignment.topCenter,
                              fit: BoxFit.fitWidth,
                              
                                               
                                             ):
                           
                    
                              SvgPicture.asset(
                              svgPath,
                              height: heightsvg,
                              width: widthsvg,
                              
                                               
                                             ),
                   
                 ),
               ),
             ),
           ),
           
           Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                //topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Theme.of(context).cardColor,
            ),
            child: Text(
              title,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          ],
          ),
                   
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle,
                            style: GoogleFonts.lato(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                                color: Theme.of(context).highlightColor,)
                ),
                 Row(
                   children: [
                     Text('Click to Visualize your progress.',
                                style: GoogleFonts.lato(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                    color: Theme.of(context).hintColor,)
                                     ),
                                      SizedBox(width: 10),
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: SvgPicture.asset(
                                    'assets/Reportsicon/backhand-index-pointing-right-svgrepo-com.svg',
                                  ),
                                ),
                   ],
                 ),
                // AnimatedTextKit(
                //         animatedTexts: [
                //           TypewriterAnimatedText(
                //             subtitle,
                //             textStyle: GoogleFonts.lato(
                //               fontSize: 20.0,
                //               fontWeight: FontWeight.bold,
                //                 color: Theme.of(context).highlightColor,
                      
                //             ),
                //          cursor:'.',
                //             speed: Duration(milliseconds: 120),
                //           ),
                //         ],
                //         isRepeatingAnimation: true,
                //         displayFullTextOnTap: true,
                //         stopPauseOnTap: true,
                //         repeatForever: true,
                //       ),
                // Text(
                //   info,
                //   style: GoogleFonts.lato(
                //     color: Theme.of(context).hintColor,
                //     fontSize: 17,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
               
               
              ],
            ),
          ),
        ],
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
