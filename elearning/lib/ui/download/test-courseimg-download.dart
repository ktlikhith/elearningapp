import 'dart:io';  // For file handling
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // For making HTTP requests
import 'package:path_provider/path_provider.dart';  // For getting the local storage directory

// Function to download the image from the given URL and save it to the provided path
Future<String> downloadImage(String url, String fileName) async {
  try {
    // Send a GET request to the URL
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Get the directory to store the downloaded file
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      // Write the file to the specified path
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print(filePath);

      return filePath;  // Return the path where the file is saved
    } else {
      throw Exception("Failed to download image.");
    }
  } catch (e) {
    throw Exception("Error downloading image: $e");
  }
}



class ImageDisplayExample extends StatefulWidget {
  @override
  _ImageDisplayExampleState createState() => _ImageDisplayExampleState();
}

class _ImageDisplayExampleState extends State<ImageDisplayExample> {
  String? _imagePath;  // Variable to hold the image path

  @override
  void initState() {
    super.initState();
    _downloadAndDisplayImage();
  }

  // Function to download the image and update the UI with the saved path
  void _downloadAndDisplayImage() async {
    String imageUrl = "https://lxp-demo2.raptechsolutions.com/webservice/pluginfile.php/899/course/overviewfiles/0_CxTlR_ZVQwpYf3d9.png?token=dc2fd6764f45007ef43cd44c617bdb71";
    String fileName = "downloaded_image.jpg";  // You can specify any file name

    try {
      String filePath = await downloadImage(imageUrl, fileName);  // Download the image
      setState(() {
        _imagePath = filePath;  // Set the downloaded image path
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Downloaded Image Example")),
      body: Center(
        child: _imagePath != null
            ? Image.file(File(_imagePath!))  // Display the image using Image.file
            : CircularProgressIndicator(),  // Show a loading indicator while the image is downloading
      ),
    );
  }
}
