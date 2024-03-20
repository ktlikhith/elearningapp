import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildCourseSection() {
  return Container(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
          'Video ', // Replace with actual video title
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0), 
            // Duration text with icon
            Row(
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
              //color: Colors.grey.withOpacity(0.5), // Border color
              width: 1.0, // Border width
    ),
    borderRadius: BorderRadius.circular(8.0), // Border radius
  ),
              child: Stack(
                alignment: Alignment.center,
                //color:Colors.grey,
                children: [
                  IconButton(
                    icon: Icon(Icons.play_circle_filled, size: 40.0, color: Colors.black),
                    onPressed: () {
                      // Add functionality to play the video
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0), // Add spacing between duration and title
        // Title below the video section
        Text(
          'Video Titlejwqdjbjbqjdbbjehhrbfnbhqgerbn frnebhgehrbnbfnbvhgqrbrh2bqbyfh2gb hgy', // Replace with actual video title
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0), // Add spacing between title and status
        // Status and due date
        Row(
          children: [
            // Status
            Column(
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
            SizedBox(width: 16.0), // Add spacing between status and due date
            // Due date
            Column(
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
            SizedBox(width: 16.0),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                // Add functionality for download button
              },
            ),
            SizedBox(width: 16.0),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Add functionality for more button
              },
            ),
          ],
        ),
        SizedBox(height: 8.0), // Add spacing between status and download/more options
        // Download icon and more options
        
      ],
    ),
  );
}
