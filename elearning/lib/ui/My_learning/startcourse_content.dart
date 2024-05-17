
import 'package:elearning/services/course_content.dart';

import 'package:elearning/ui/Webview/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetailsPage extends StatefulWidget {
  final String token;
  final String courseId;
  final String courseName;

  CourseDetailsPage(this.token, this.courseId, this.courseName);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  List<Map<String, dynamic>>? _courseContentData;

  @override
  void initState() {
    super.initState();
    _fetchCourseContent();
  }

  Future<void> _fetchCourseContent() async {
    try {
      final courseContentResponse =
          await CourseContentApiService().fetchCourseContentData(widget.token, widget.courseId);

      // Check if the response contains 'course_content'
      if (courseContentResponse.containsKey('course_content')) {
        final List<dynamic> courseContent = courseContentResponse['course_content'];

        if (mounted) {
          setState(() {
            _courseContentData = List<Map<String, dynamic>>.from(courseContent);
          });
        }
      } else {
        throw Exception('Response does not contain course content');
      }
    } catch (e) {
      print('Error fetching course content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.courseName),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _courseContentData != null ? _buildCourseContent() : _buildShimmerCourseContent(),
    );
  }
Widget _buildCourseContent() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var section in _courseContentData!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    section['expanded'] = !(section['expanded'] ?? false);
                  });
                },
                child: Container(
                  
                   decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(10), // Set border radius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // Adjust padding as needed
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10), // Add padding to the text from left
                          child: Text(
                            section['name'] ?? 'Section Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(220, 6, 6, 6),
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        section['expanded'] ?? false
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color:  Color.fromARGB(255, 6, 6, 6),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (section['expanded'] ?? false)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      for (var module in section['modules'])
                        Column(
                          children: [
                            ListTile(
                              leading: _buildModuleIcon(module['modicon']),
                              title: Text(
                                module['name'] ?? 'Module Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 6, 6),
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                if (module['url'] != null && module['url'].isNotEmpty) {
                                  String moduleUrl = module['url'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WebViewPage(module['name'] ?? 'Module Name', moduleUrl),
                                    ),
                                  );
                                }
                              },
                            ),
                              Divider(), 
                          ],
                        ),
                   // Major divider after all modules in the section
                    ],
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}


  Widget _buildShimmerCourseContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < 5; i++) // Add shimmer placeholders while loading
            Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150, // Adjust width as needed
                          height: 22, // Adjust height as needed
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: _buildShimmerModuleIcon(), // Use shimmer effect for icons
                  title: _buildShimmerText(), // Use shimmer effect for text
                ),
                Divider(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildModuleIcon(String? iconUrl) {
    if (iconUrl != null && iconUrl.isNotEmpty) {
      return SvgPicture.network(
        iconUrl,
        width: 26,
        height: 26,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) {
          // Placeholder icon while loading
          return _buildShimmerModuleIcon();
        },
      );
    } else {
      // Placeholder icon if the icon URL is invalid or empty
      return Icon(Icons.error_outline);
    }
  }

  Widget _buildShimmerModuleIcon() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 40,
        height: 40,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerText() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 150, // Adjust width as needed
        height: 22, // Adjust height as needed
        color: Colors.grey[300],
      ),
    );
  }
}
