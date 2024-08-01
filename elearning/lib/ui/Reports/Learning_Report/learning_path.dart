import 'package:elearning/services/allcourse_service.dart';
import 'package:elearning/ui/Reports/Learning_Report/learning_detail.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';

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
        title: Text('Learning Paths'),
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
            return Center();//child: Text('Error: ${snapshot.error}')
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
            color: Theme.of(context).hintColor.withOpacity(0.2),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  learningPath.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: learningPath.progress / 100,
                              strokeWidth: 20,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStatusColor(learningPath.progress),
                              ),
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
                      ),
                      SizedBox(height: 15),
                      Text(
                        _getStatusText(learningPath.progress),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(learningPath.progress),
                        ),
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
}
