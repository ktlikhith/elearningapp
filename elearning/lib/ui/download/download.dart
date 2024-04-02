import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
         backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(RouterManger.homescreen);
          },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Container
              
              Container(
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: Colors.grey),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Top Right Section
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: const Text('Size: 50MB'), // Replace with actual size
          ),
          Container(
            child: const Text('Format: MP4'), // Replace with actual format
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      // Title
      const Text(
        'Downloadable Video Title',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8.0),
      // Thumbnail (Replace AssetImage with your actual image)
      // Image.asset('assets/thumbnail_image.jpg', width: 120.0, height: 120.0),
      Container(
              width: double.infinity,
              height: 200.0, // Adjust the height of the video container
              color: Colors.grey, // Placeholder color for the video
              // Here you can add your video player widget
              child: IconButton(
              icon: const Icon(Icons.play_circle_filled, size: 64.0, color: Colors.white),
              onPressed: () {
                // Add functionality to play the video
              },
            ),
            ),
            
     
      const SizedBox(height: 16.0),
      // Footer Section
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: Not Downloaded'), // Replace with actual status
              SizedBox(height: 8.0),
              Text('Due Date: 2024-04-01'), // Replace with actual due date or make optional
            ],
          ),
          Row(
            children: [
              // Download Button
              // ElevatedButton(
              //   onPressed: () {
              //     // Handle download logic
              //   },
                //child: 
                IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: const FaIcon(FontAwesomeIcons.download, color: Colors.black,), 
      onPressed: () { print("Pressed"); }
     ),
              
              const SizedBox(width: 8.0),
              // More Options Button (Optional)
              
                 IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: const FaIcon(FontAwesomeIcons.ellipsis , color: Colors.black, ), 
      onPressed: () { print("Pressed"); }
     ),
              
            ],
          ),
        ],
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
