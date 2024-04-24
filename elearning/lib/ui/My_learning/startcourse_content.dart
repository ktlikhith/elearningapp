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
        title: 'PDF Files',
        subSections: [
          CourseSubSection(title: 'Introduction to PDFs'),
          CourseSubSection(title: 'Advanced PDF Techniques'),
          CourseSubSection(title: 'PDF Design Principles'),
          CourseSubSection(title: 'Dummy PDF 1'), // Add a dummy PDF
          CourseSubSection(title: 'Dummy PDF 2'), // Add another dummy PDF
        ],
      ),
      CourseSection(
        title: 'Video Files',
        subSections: [
          CourseSubSection(title: 'Introduction to Videos'),
          CourseSubSection(title: 'Advanced Video Techniques'),
          CourseSubSection(title: 'Video Editing Basics'),
        ],
      ),
      CourseSection(
        title: 'H5P Content',
        subSections: [
          CourseSubSection(title: 'H5P Interactive Quiz'),
          CourseSubSection(title: 'H5P Drag and Drop'),
          CourseSubSection(title: 'H5P Presentation'),
        ],
      ),
      CourseSection(
        title: 'SCORM Content',
        subSections: [
          CourseSubSection(title: 'SCORM Introduction'),
          CourseSubSection(title: 'SCORM Quiz'),
          CourseSubSection(title: 'SCORM Interactive Module'),
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
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
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
