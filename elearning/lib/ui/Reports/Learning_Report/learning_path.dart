import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Reports/Learning_Report/learning_detail.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _learningPathData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: Something went wrong'));//child: Text('Error: ${snapshot.error}')
          } else if (snapshot.hasData && (snapshot.data!['learningpathdetail'] as List).isEmpty) {
            return Center(child: Text('No learning paths available'));
          } else {
            List learningPaths = snapshot.data!['learningpathdetail'];
            List progressList = snapshot.data!['learningpath_progress'];
            return Container(
 
  child: ListView.builder(
    itemCount: learningPaths.length,
    itemBuilder: (context, index) {
      var learningPath = LearningPathDetail.fromJson(learningPaths[index], progressList);
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearningPathDetailScreen(learningPath: learningPath,token: widget.token,),
            ),
          );
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
           // color: Theme.of(context).hintColor.withOpacity(0.2),
            
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
      height: 60,
      width: 100,
      child: Stack(
        children: [
         
          // Image with error handling
          Image.network(
                      
                          '${Constants.baseUrl}${learningPath.imageUrl}',
                          height: 60,
                          width: 100,
                          fit: BoxFit.fill,
                        
                          
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/coursedefaultimg.jpg',
                                  height: 60,
                          width: 100,
                              fit: BoxFit.fill,
                            );
                          },
                        ),


        ],
      ),
    ),

                    ),
                    Container(
                     child: Column(
                       children: [
                         Text('Duration:${learningPath.duration}',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                         Text('Courses:${learningPath.nocourses}',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),)
                       ],
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
                              LinearPercentIndicator(
                                barRadius:Radius.circular(10),
                                percent: learningPath.progress / 100,
                              width:100,
                              lineHeight: 8,
                                                       
                                // strokeWidth: 13,
                                backgroundColor: Color.fromARGB(255, 170, 167, 167),
                                progressColor: 
                                  _getStatusColor(learningPath.progress),
                                
                              ),
                              
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
  ),
);

          }
        },
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
