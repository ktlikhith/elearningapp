import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Reports/Learning_Report/learning_detail.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:elearning/utilites/networkerrormsg.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class LearningPathScreen extends StatefulWidget {
  final String token;
  const LearningPathScreen({Key? key, required this.token}) : super(key: key);

  @override
  _LearningPathScreenState createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  late Future<Map<String, dynamic>> _learningPathData;
  

  @override
  void initState() {
    super.initState();
    _learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
  }
   Future<void>  refrseh()async{
    context.read<LearningPathProvider>().fetchLearningPaths();
    setState(() {
       _learningPathData = LearningPathApiService.fetchLearningPathData(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Path'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: refrseh,
        child: 
         Consumer<LearningPathProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.error != null) {
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
          } else if (provider.learningPaths.isEmpty) {
            return Center(child: Text('No learning paths available'));
          } else {
            print(provider.learningPaths);
            return ListView.builder(
              itemCount: provider.learningPaths.length,
              itemBuilder: (context, index) {
                final learningPath = provider.learningPaths[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningPathDetailScreen(
                          learningPath: learningPath,
                          index: index,
                          token: widget.token,
                        ),
                      ),
                    );
                    // Refresh data after navigating back
                   // await context.read<LearningPathProvider>().fetchLearningPaths();
                  },
          child: Container(
        
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  // color: Theme.of(context).secondaryHeaderColor.withOpacity(0.4),
                  color:Theme.of(context).cardColor,
                ),
             color: Theme.of(context).hintColor.withOpacity(0.2),
              
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                         width: MediaQuery.of(context).size.width*0.8,
        
                      child: Center(
                        child: Text(
                                         '${learningPath.name}',
                                         maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              
                                         style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                         color: Theme.of(context).primaryColor
                                         ),
                                       ),
                      ),
                    ),
                     
               
                   
                  ],
                ),
               
                      
                  
           Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
              child: 
                   SizedBox(
        height: 55,
            width: MediaQuery.of(context).size.width*0.22,
        child: Stack(
          children: [
           
            // Image with error handling
            Container(
              color: Colors.white,
              child: Image.network(
                          
                              '${Constants.baseUrl}${learningPath.imageUrl}',
                              height: 55,
                              width: MediaQuery.of(context).size.width*0.25,
                              fit: BoxFit.fill,
                            
                              
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/coursedefaultimg.jpg',
                                      height: 55,
                             width: MediaQuery.of(context).size.width*0.25,
                                  fit: BoxFit.fill,
                                );
                              },
                            ),
            ),
        
        
          ],
        ),
            ),
        
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16.0),
                        child: Container(
                         child: Column(
                          
                          crossAxisAlignment:CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Text('Duration:',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900),),
                                 Text('${learningPath.duration}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
                               ],
                             ),
                             Row(
                               children: [
                                Text('Courses :',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w900),),
                                 Text('${learningPath.nocourses}',style: TextStyle(fontSize: 13,fontWeight:  FontWeight.w500),),
                               ],
                             )
                           ],
                         ),
                         
                        ),
                      ),
        
                           Column(
                      children: [
                        // Stack(
                        //   fit: StackFit.expand,
                        //   children: [
                            Padding(
                          padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width*0.03),
                          child: Text(
                            _getStatusText(learningPath.progress),
                            style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(learningPath.progress),
                            ),
                          ),
                        ),
                          
                          //   Center(
                          //     child: Text(
                          //       '${learningPath.progress}%',
                          //       style: TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        // ),
                        SizedBox(height: 10),
                        Row(
                              children: [
                                Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 8,
                                                width: MediaQuery.of(context).size.width * 0.19,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF3ACBE8).withOpacity(0.3),
                                                      Color(0xFF0D85D8).withOpacity(0.3),
                                                      Color(0xFF0041C7).withOpacity(0.3),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if(learningPath.progress>7)
                                              Container(
                                                height: 8,
                                                width: MediaQuery.of(context).size.width * 0.19 * (learningPath.progress / 100),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFF3ACBE8),
                                                      Color(0xFF0D85D8),
                                                      Color(0xFF0041C7),
                                                    ],
                                                    stops: [0.0, 0.5, 1.0],
                                                  ),
                                                ),
                                              ),
                                              if(learningPath.progress < 7 && learningPath.progress>0)
                                                Positioned(
                                                  left: MediaQuery.of(context).size.width * 0.8 *0.028-8,
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF3ACBE8),
                                                          Color(0xFF0D85D8),
                                                          Color(0xFF0041C7),
                                                        ],
                                                        stops: [0.0, 0.5, 1.0],
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
                                              if (learningPath.progress >= 7&&learningPath.progress!=100)
                                                Positioned(
                                                  left: MediaQuery.of(context).size.width * 0.2* (learningPath.progress/ 100) - 8,
                                                  child: Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF3ACBE8),
                                                          Color(0xFF0D85D8),
                                                          Color(0xFF0041C7),
                                                        ],
                                                        stops: [0.0, 0.5, 1.0],
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
                                
                                        
                                        ],
                                      ),
                                // LinearPercentIndicator(
                                //   barRadius:Radius.circular(10),
                                //   percent: learningPath.progress / 100,
                                // width:100,
                                // lineHeight: 8,
                                                         
                                //   // strokeWidth: 13,
                                //   backgroundColor: Color.fromARGB(255, 170, 167, 167),
                                //   progressColor: 
                                //     _getStatusColor(learningPath.progress),
                                  
                                // ),
                                
                            Center(
                              child: Text(
                                '${learningPath.progress}%',
                               
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                              
                            ),
                      ],
                    ),
                    ],
                  ),
               
              ],
            ),
          ),
        );
            },
          
          );
          }
        
        
            
          },
        ),
      ),
    );
  }


String _getStatusText(int progress) {
    if (progress == 0) {
      return 'Not Started';
    } else if (progress == 100) {
      return 'Completed';
    } else {
      return 'In Progress';
    }
  }

  Color _getStatusColor(int progress) {
    if (progress == 0) {
      return Colors.red;
    } else if (progress == 100) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }
   Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 60,
        width: 100,
        color: Colors.white,
      //  margin: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}
