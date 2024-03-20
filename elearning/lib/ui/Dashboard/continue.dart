import 'package:flutter/material.dart';

Widget buildContinueLearningSection() {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 16.0),
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200.0, // Adjust the height of the video container
              color: Colors.grey, // Placeholder color for the video
              // Here you can add your video player widget
            ),
            IconButton(
              icon: Icon(Icons.play_circle_filled, size: 64.0, color: Colors.white),
              onPressed: () {
                // Add functionality to play the video
              },
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Add functionality for the back button
                },
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Add functionality for the more button
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Icon(Icons.access_time, size: 16.0),
            SizedBox(width: 8.0),
            Text('2 hours ago'),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          'Title of the Course',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

