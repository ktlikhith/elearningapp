import 'package:flutter/material.dart';

class CourseContentPage extends StatelessWidget {
  const CourseContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Content'),
      ),
      body: buildCourseContent(),
    );
  }

  Widget buildCourseContent() {
    // Mock data for course breakdown
    List<CourseSection> courseSections = [
      CourseSection(
        title: ' PDF Files',
        subSections: [
          CourseSubSection(title: 'Introduction to PDFs'),
          CourseSubSection(title: 'Advanced PDF Techniques'),
          CourseSubSection(title: 'PDF Design Principles'),
        ],
      ),
      CourseSection(
        title: ' Video Files',
        subSections: [
          CourseSubSection(title: 'Introduction to Videos'),
          CourseSubSection(title: 'Advanced Video Techniques'),
          CourseSubSection(title: 'Video Editing Basics'),
        ],
      ),
    ];

    return ListView.builder(
      itemCount: courseSections.length,
      itemBuilder: (context, index) {
        final section = courseSections[index];
        return ExpansionTile(
  title: Text(
    section.title,
    style: TextStyle(
      fontSize: 20.0, // Change the font size to your desired value
      fontWeight: FontWeight.bold, // Optional: you can also change the font weight
    ),
  ),
  children: section.subSections
      .map((subSection) => ListTile(
            title: Text(subSection.title),
            onTap: () {
              // Handle sub-section tap, e.g., navigate to content page
              // or show content based on sub-section
              print('Pressed on ${subSection.title}');
            },
          ))
      .toList(),
);

      },
    );
  }
}

class CourseSection {
  final String title;
  final List<CourseSubSection> subSections;

  CourseSection({required this.title, required this.subSections});
}

class CourseSubSection {
  final String title;

  CourseSubSection({required this.title});
}
