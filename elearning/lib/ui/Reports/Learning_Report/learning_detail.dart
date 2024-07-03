import 'package:flutter/material.dart';
import 'package:elearning/services/learninpath_service.dart';

class LearningPathDetailScreen extends StatelessWidget {
  final LearningPathDetail learningPath;

  LearningPathDetailScreen({required this.learningPath});

  @override
  Widget build(BuildContext context) {
    List<LearningPathProgress> courses = learningPath.learningpathProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text(learningPath.name),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: courses.isEmpty
          ? Center(child: Text('No courses available'))
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                var course = courses[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to course details screen if needed
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        boxShadow: [
                        
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width * 0.7,
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
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width * 0.7 * (course.progress / 100),
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
                                    if (course.progress > 0)
                                      Positioned(
                                        left: MediaQuery.of(context).size.width * 0.7* (course.progress / 100) - 20,
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
                                SizedBox(width: 8),
                                Text(
                                  '${course.progress.toInt()}%',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
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
