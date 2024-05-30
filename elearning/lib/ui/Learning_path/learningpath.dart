import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/learninpath_service.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class LearningPathPage extends StatelessWidget {
  final String token;

  const LearningPathPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: LearningPathApiService.fetchLearningPathData(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSkeleton(); // Show shimmer skeleton while loading
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

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3, // Show 3 dummy containers while loading
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color to white
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    color: Colors.grey, // Placeholder color for image
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 20.0,
                    color: Colors.grey, // Placeholder color for text
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 10.0,
                    color: Colors.grey, // Placeholder color for text
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 10.0,
                    color: Colors.grey, // Placeholder color for text
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLearningPathPage(BuildContext context, Map<String, dynamic> learningPathData) {
    final learningPathDetail = learningPathData['learningpathdetail'][0];
    final List<dynamic> courseProgress = learningPathData['learningpath_progress'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Learning Path'),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
           onPressed: () {
          Navigator.pop(context);
        },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Learning Path Image
                    Image.network(
                      '${Constants.baseUrl}${learningPathDetail['learningpathimage']}',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16.0),
                    // Learning Path Details
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0, // Adjust the width as needed
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            learningPathDetail['learningpathname'],
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            removeHtmlTags(learningPathDetail['discriotion']),
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,
                            color: Colors.grey[600],),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  size: 16.0,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Duration: ${learningPathDetail['duration']}',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                SizedBox(width: 30.0),
                                FaIcon(
                                  FontAwesomeIcons.book,
                                  size: 16.0,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'NoCourses: ${learningPathDetail['nocourses']}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Learning Path Progress
                    Text(
                      'Learning Content',
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    // List of Courses
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: courseProgress.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.0),
                      itemBuilder: (context, index) {
                        final course = courseProgress[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         CourseDetailsPage(token, course.id,course.name),
                  //   ),
                  // );
                  //           },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      '${course['courseimg']}?token=$token',
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    removeHtmlTags(course['coursename']),
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    removeHtmlTags(course['coursedec']),
                                    style: TextStyle(fontSize: 16.0,color: Colors.grey[600]),
                                    
                                  ),
                                  SizedBox(height: 12.0),
                                  Container(
                                    height: 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: course['courseprogressbar'] / 100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
    return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
  }
}
