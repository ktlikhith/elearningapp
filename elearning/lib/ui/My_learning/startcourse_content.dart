import 'package:flutter/material.dart';

class CourseDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Theme.of(context).primaryColor,
          title: Text('Course Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Image
              Container(
                height: 300, // Adjust the height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/img1.jpeg'), // Correct image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Curved Edge Container
              Container(
                margin: EdgeInsets.all(20), // Adjust the margin to overlap the image
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the Course
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Course Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Description of the Course
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Course Description goes here...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // Content Headers
                    ExpansionTile(
                      leading: Icon(Icons.play_circle_filled), // Icon for video content
                      title: Text(
                        'Module 1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('GO1 | SCORM | PDF | Quiz'), // Dummy content types
                      children: [
                        ListTile(
                          leading: Icon(Icons.play_circle_filled), // Icon for video content
                          title: Text('Video Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.insert_drive_file), // Icon for SCORM content
                          title: Text('SCORM Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.picture_as_pdf), // Icon for PDF content
                          title: Text('PDF Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.quiz), // Icon for quiz content
                          title: Text('Quiz Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      ],
                    ),
                    // Module 2
                    ExpansionTile(
                      leading: Icon(Icons.play_circle_filled),
                      title: Text(
                        'Module 2',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('GO1 | SCORM | PDF | Quiz'),
                      children: [
                        ListTile(
                          leading: Icon(Icons.play_circle_filled),
                          title: Text('Video Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.insert_drive_file),
                          title: Text('SCORM Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.picture_as_pdf),
                          title: Text('PDF Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.quiz),
                          title: Text('Quiz Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      ],
                    ),
                    // Module 3
                    ExpansionTile(
                      leading: Icon(Icons.play_circle_filled),
                      title: Text(
                        'Module 3',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('GO1 | SCORM | PDF | Quiz'),
                      children: [
                        ListTile(
                          leading: Icon(Icons.play_circle_filled),
                          title: Text('Video Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.insert_drive_file),
                          title: Text('SCORM Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.picture_as_pdf),
                          title: Text('PDF Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.quiz),
                          title: Text('Quiz Content'),
                          onTap: () {
                            // Handle tap
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
