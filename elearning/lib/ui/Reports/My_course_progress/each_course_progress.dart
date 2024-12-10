import 'dart:async';

import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/Reports/My_course_progress/activity_progress.dart';
import 'package:elearning/utilites/networkerrormsg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CourseProgressPage extends StatefulWidget {
  final String token;
  final String filter;

  CourseProgressPage({required this.token, required this.filter});

  @override
  _CourseProgressPageState createState() => _CourseProgressPageState();
}

class _CourseProgressPageState extends State<CourseProgressPage> {
  late Future<HomePageData> _homePageData;
   OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;
  Timer? _tooltipTimer;
  bool timertoshowhint=false;
 

  @override
  void initState() {
    super.initState();
    _homePageData = HomePageService.fetchHomePageData(widget.token);
    

  }
   @override
  void dispose() {
    _hideTooltip(); // Ensure tooltip is hidden when the screen is disposed
    super.dispose();
  }
 
  void _showTooltip(BuildContext context) {
    
    if (_isTooltipVisible) return;

    setState(() {
      _isTooltipVisible = true;
    });

    _overlayEntry = _createOverlayEntry(context);
    Overlay.of(context)?.insert(_overlayEntry!);

    _tooltipTimer = Timer(Duration(seconds: 3), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _tooltipTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isTooltipVisible = false;
    });
  }

 OverlayEntry _createOverlayEntry(BuildContext context) {
  return OverlayEntry(
    builder: (context) => Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top + 8.0,
      right: 16.0,
      left: 16.0, // Make sure we add `left` to give width flexibility
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double maxWidth = MediaQuery.of(context).size.width - 32.0; // Ensure padding from both sides

            return Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,// Restrict the maximum width of the container based on screen size
              ),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Tap on the Course to view Activity Status.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left, // Adjust alignment if necessary
                softWrap: true, // Ensure text wraps to the next line if needed
              ),
            );
          },
        ),
      ),
    ),
  );
}



  List<CourseData> filterCourses(List<CourseData> courses, String filter) {
    switch (filter) {
      case 'not started':
        return courses.where((course) => course.courseProgress == 0).toList();
      case 'in progress':
        return courses.where((course) => course.courseProgress>0&&course.courseProgress<100).toList();
      case 'completed':
        return courses.where((course) => course.courseProgress == 100).toList();
      default:
        return courses;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Progress'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
         actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              if (_isTooltipVisible) {
                _hideTooltip();
              } else {
                _showTooltip(context);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
           context.read<HomePageProvider>().fetchAllCourses();
        },
        child:  Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return
                Center(child: CircularProgressIndicator());
  
                   
          }

          if (provider.error != null) {
            if (provider.error.toString().contains('Connection reset by peer')||provider.error.toString().contains('Connection timed out')||provider.error.toString().contains('ClientException with SocketException: Failed host lookup')) {
  showNetworkError(context);
        return Center(child: CircularProgressIndicator());
  } else{
    // Show the general error message to the user
    SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong please try again.'
)),
    );
    });
        // Handle error state - fallback to default logo
      
  
           return Center(child: CircularProgressIndicator());
  }
          }

          if (provider.allCourses.isEmpty) {
            return Center(child: Text("Something went wrong No / courses data is not available."));
          }

                 if(timertoshowhint!=true)
                  
                   Future.delayed(Duration(seconds: 1),(){
                  
                 _showTooltip(context);
                 timertoshowhint=true;
                 
          
            });
                final filteredCourses = filterCourses(provider.allCourses, widget.filter);
                 if( filteredCourses.length!=0){
                return ListView.builder(
                  physics:AlwaysScrollableScrollPhysics(),
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                       
                          return GestureDetector(
                            
                            onTap: () async{
                            await  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityDetailsPage(widget.token, course.id, course.name),
                                ),
                              );
                              setState(() {
                                 _homePageData = HomePageService.fetchHomePageData(widget.token);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CourseProgressBar(
                                courseName: course.name,
                                progress: course.courseProgress.toDouble(),
                              ),
                            ),
                          );
                        },
                        
                );
                 }else   return Center(child: Text('No data found',style: TextStyle(fontWeight: FontWeight.bold),));
                  
            
              }
              
             
            
            
          ),
        ),
      
      
      
    );
  }
}

class CourseProgressBar extends StatelessWidget {
  final String courseName;
  final double progress;

  CourseProgressBar({
    required this.courseName,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            courseName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3ACBE8).withOpacity(0.3), // Start color with opacity
                          Color(0xFF0D85D8).withOpacity(0.3), // Mid color with opacity
                          Color(0xFF0041C7).withOpacity(0.3), // End color with opacity
                        ],
                      ),
                    ),
                  ),if(progress>7)
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.75 * (progress / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF3ACBE8),
                          Color(0xFF0D85D8),
                          Color(0xFF0041C7),
                        ],
                        stops: [0.0, 0.5, 1.0], // Defining the stops for the gradient
                      ),
                    ),
                  ),
                  if(progress <7 && progress>0)
                   Positioned(
                      left: MediaQuery.of(context).size.width * 0.75 *0.07-20,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF3ACBE8),
                              Color(0xFF0D85D8),
                              Color(0xFF0041C7),
                            ],
                            stops: [0.0, 0.5, 1.0], // Defining the stops for the gradient
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                   if (progress >= 7)
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.75 * (progress / 100) - 20,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF3ACBE8),
                              Color(0xFF0D85D8),
                              Color(0xFF0041C7),
                            ],
                            stops: [0.0, 0.5, 1.0], // Defining the stops for the gradient
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 8),
              Text(
                '${progress.toInt()}%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
