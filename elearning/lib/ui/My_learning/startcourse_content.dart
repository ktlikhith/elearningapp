

import 'package:elearning/services/course_content.dart';
import 'package:elearning/ui/My_learning/webviewpage.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final String token;
  final String courseId;

  CourseDetailsPage(this.token, this.courseId);

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
   
      final courseContent = await CourseContentApiService()
          .fetchCourseContentData(widget.token, widget.courseId);
      print(courseContent);
      if (mounted) {
        setState(() {
          _courseContentData = courseContent;
        });
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
        title: Text('Course Details'),
      ),
      body: _courseContentData != null
          ? _buildCourseContent()
          : Center(child: CircularProgressIndicator()),
    );
  }
Widget _buildCourseContent() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var section in _courseContentData!)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.orange, // Add blue background color for the section row
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      section['name'] ?? 'Section Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 224, 222, 219),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              for (var module in section['modules'])
                ListTile(
                  leading: _buildModuleIcon(module['modicon']! + '?token=${widget.token}'),
                  title: Text(module['name'] ?? 'Module Name'),
                 onTap: () {
  if (module['url'] != null && module['url'].isNotEmpty) {
    String modifiedUrl = module['url']! + '?token=${widget.token}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(module['name'] ?? 'Module Name', modifiedUrl),
      ),
    );
  }
},
                ),
              Divider(), // Add a divider between modules
            ],
          ),
      ],
    ),
  );
}



Widget _buildModuleIcon(String? iconUrl) {
  print('$iconUrl');
  //     DecorationImage(
  //                 image: NetworkImage( '$iconUrl'),
  //                 fit: BoxFit.cover,
  //               );
  if (iconUrl != null && iconUrl.isNotEmpty) {
  //   // Check if the URL contains a query parameter (?)
  //   if (iconUrl.contains('?')) {
  //     // Append additional parameters to the URL to ensure correct image loading
  //     iconUrl += '&time=' + DateTime.now().millisecondsSinceEpoch.toString();
  //   } else {
  //     // If no query parameter exists, add one to the URL
  //     iconUrl += '?time=' + DateTime.now().millisecondsSinceEpoch.toString();
  //   }


    return Image.network(
      iconUrl,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Placeholder icon if loading the modicon fails
        return Icon(Icons.error_outline);
      },
    );
  } else {
    // Placeholder icon if modicon URL is invalid or empty
    return Icon(Icons.error_outline);
  }
}

}
