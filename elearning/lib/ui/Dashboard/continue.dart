import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';

class CustomDashboardWidget extends StatelessWidget {
  final int numberOfVideos;

  CustomDashboardWidget({this.numberOfVideos = 3}); // Change to 3 videos

  @override
  Widget build(BuildContext context) {
    return Container(
      // Assuming you have some styling for your dashboard container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouterManger.continuescreen);
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (numberOfVideos > 0) ...[
                  SizedBox(
                    width: 120,
                    child: _buildSection(),
                  ),
                ],
                if (numberOfVideos > 1) SizedBox(width: 10), // Add spacing if there are more videos
                if (numberOfVideos > 1) ...[
                  // Display additional video sections if there are more than one video
                  SizedBox(
                    width: 120,
                    child: _buildSection(),
                  ),
                ],
                if (numberOfVideos > 2) SizedBox(width: 10), // Add spacing if there are more videos
                if (numberOfVideos > 2) ...[
                  // Display additional video sections if there are more than two videos
                  SizedBox(
                    width: 120,
                    child: _buildSection(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Container(
      width: 120, // Adjust the width as needed
      color: Color.fromARGB(255, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120, // Adjust the height as needed
            color: Colors.blueGrey, // Replace with your video widget
            child: Center(
              child: IconButton(
                icon: Icon(Icons.play_circle_fill),
                onPressed: () {
                  // Add your play button functionality here
                },
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.white, // Adjust as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    // Add your info icon functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Add your option icon functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
