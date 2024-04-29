import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:flutter/material.dart';

class LearningPathPage extends StatelessWidget {
  final String token;

  const LearningPathPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: LearningPathApiService.fetchLearningPathData(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final learningPathData = snapshot.data!;
          return _buildLearningPathPage(context, learningPathData);
        }
      },
    );
  }

  Widget _buildLearningPathPage(BuildContext context, Map<String, dynamic> learningPathData) {
    // Build your UI using the learningPathData
    // For example:
    final learningPathDetail = learningPathData['learningpathdetail'][0];
    final List<dynamic> courseProgress = learningPathData['learningpath_progress'];

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Theme.of(context).primaryColor,
        title: Text('Learning Path'),
         leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.morescreen,arguments: token);
          },
        ),
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Learning Path Overview Section
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      learningPathDetail['learningpathname'],
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      learningPathDetail['discriotion'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Duration: ${learningPathDetail['duration']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    // Custom Progress Bar Widget
                    CustomProgressBar(progress: 0.5), // Use the actual progress value here
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Individual Course Sections
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: courseProgress.length,
              itemBuilder: (context, index) {
                final course = courseProgress[index];
                return Card(
                  elevation: 4.0,
                  child: InkWell(
                    onTap: () {
                      // Navigate to course details screen with token
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Course Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              course['courseimg'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Course Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course['coursename'],
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  course['coursedec'],
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 8.0),
                                CustomProgressBar(progress: 0.3), // Use the actual progress value here
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double progress;

  const CustomProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: Colors.grey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.green,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
