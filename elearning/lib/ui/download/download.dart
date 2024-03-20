import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class DownloadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Container
              
              Container(
  padding: EdgeInsets.all(16.0),
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
            margin: EdgeInsets.only(right: 8.0),
            child: Text('Size: 50MB'), // Replace with actual size
          ),
          Container(
            child: Text('Format: MP4'), // Replace with actual format
          ),
        ],
      ),
      SizedBox(height: 16.0),
      // Title
      Text(
        'Downloadable Video Title',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8.0),
      // Thumbnail (Replace AssetImage with your actual image)
      Image.asset('assets/thumbnail_image.jpg', width: 120.0, height: 120.0),
      SizedBox(height: 16.0),
      // Footer Section
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
      icon: FaIcon(FontAwesomeIcons.download, color: Colors.black,), 
      onPressed: () { print("Pressed"); }
     ),
              
              SizedBox(width: 8.0),
              // More Options Button (Optional)
              
                 IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
      icon: FaIcon(FontAwesomeIcons.ellipsis , color: Colors.black, ), 
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
