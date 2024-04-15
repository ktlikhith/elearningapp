import 'package:elearning/ui/My_learning/ml_popup.dart';
import 'package:flutter/material.dart';

List<Widget> buildCourseSections(int courseCount, BuildContext context) {
  List<Widget> courseSections = [];

  for (int i = 0; i < courseCount; i++) {
    courseSections.add(
      Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: buildSingleCourseSection(context), // Pass the context to buildSingleCourseSection
      ),
    );
  }

  return courseSections;
}

Widget buildSingleCourseSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Video ', // Replace with actual video title
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          // Duration text with icon
          const Row(
            children: [
              Icon(Icons.timer, size: 18.0, color: Colors.grey), // Duration icon
              SizedBox(width: 4.0),
              Text(
                '2h 30m', // Replace with actual duration
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Video section with play button
          Container(
            width: 120.0, // Adjust as needed
            height: 80.0, // Adjust as needed
            // Placeholder color for the video
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0, // Border width
              ),
              borderRadius: BorderRadius.circular(8.0), // Border radius
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_filled, size: 40.0, color: Colors.black),
                  onPressed: () {
                    showMLPopup(context); // Call showMLPopup with the context
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 8.0), // Add spacing between duration and title
      // Title below the video section
      const Text(
        'Video Titlejwqdjbjbqjdbbjehhrbfnbhqgerbn frnebhgehrbnbfnbvhgqrbrh2bqbyfh2gb hgy', // Replace with actual video title
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8.0), // Add spacing between title and status
      // Status and due date
      Row(
        children: [
          // Status
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status', // Replace with actual status title
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                'In Progress', // Replace with actual status
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0), // Add spacing between status and due date
          // Due date
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due Date', // Replace with actual due date title
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                '2024-03-25', // Replace with actual due date
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16.0),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Add functionality for download button
            },
          ),
          const SizedBox(width: 16.0),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add functionality for more button
            },
          ),
        ],
      ),
      const SizedBox(height: 8.0), // Add spacing between status and download/more options
      // Download icon and more options
    ],
  );
}

void showMLPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MLPopup(); // Create an instance of MLPopup without passing context
    },
  );
}