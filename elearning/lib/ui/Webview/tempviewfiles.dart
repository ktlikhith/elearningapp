

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class PDFViewerScreen extends StatefulWidget {
//   final String url;
//   final String token;

//   const PDFViewerScreen({
//     Key? key,
//     required this.url,
//     required this.token,
//   }) : super(key: key);

//   @override
//   _PDFViewerScreenState createState() => _PDFViewerScreenState();
// }

// class _PDFViewerScreenState extends State<PDFViewerScreen> {
//   bool isLoading = true;
//   File? tempFile;

//   @override
//   void initState() {
//     super.initState();
//     _downloadAndViewPdf();
//   }

//  Future<void> _downloadAndViewPdf() async {
//   try {
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download');

//     if (!await downloadDirectory.exists()) {
//       await downloadDirectory.create(recursive: true);
//     }

//     final fileName = Uri.parse(widget.url).pathSegments.last.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
//     tempFile = await File('${downloadDirectory.path}/$fileName');

//     if (!await tempFile!.exists()) {
//       setState(() {
//         isLoading = true;
//       });

//       final response = await http.get(Uri.parse('${widget.url}&token=${widget.token}'));

//       if (response.statusCode == 200) {
//         await tempFile!.writeAsBytes(response.bodyBytes);
//       } else {
//         throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
//       }
//     }

//     if (await tempFile!.exists()) {
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       throw Exception('File not found after download: ${tempFile!.path}');
//     }
//   } catch (e) {
//     print('Error downloading PDF: $e');
//     setState(() {
//       isLoading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to load PDF. Please try again.')),
//     );
//   }
// }


//   @override
//   void dispose() {
//     // Delete the temporary file when the screen is closed
//     if (tempFile != null && tempFile!.existsSync()) {
//       tempFile!.deleteSync();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Downloading document...'),
//                 ],
//               ),
//             )
//           : tempFile != null
//               ? PDFView(
//                   filePath: tempFile!.path,
//                   enableSwipe: true,
//                   swipeHorizontal: false,
//                   autoSpacing: false,
//                   pageFling: true,
//                   onRender: (pages) => print('PDF rendered with $pages pages'),
//                   onError: (error) => print('Error loading PDF: $error'),
//                   onPageError: (page, error) => print('Page $page: Error $error'),
//                 )
//               : const Center(
//                   child: Text('Failed to load PDF.'),
//                 ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';  // Import permission handler

// class PDFViewerScreen extends StatefulWidget {
//   final String url;
//   final String token;

//   const PDFViewerScreen({
//     Key? key,
//     required this.url,
//     required this.token,
//   }) : super(key: key);

//   @override
//   _PDFViewerScreenState createState() => _PDFViewerScreenState();
// }

// class _PDFViewerScreenState extends State<PDFViewerScreen> {
//   bool isLoading = true;
//   File? tempFile;

//   @override
//   void initState() {
//     super.initState();
//     print(widget.url);
//     _downloadAndViewPdf();
//   }

//   Future<void> _downloadAndViewPdf() async {
//     try {
//       // Check for storage permission
//       var status = await Permission.storage.status;
//       if (!status.isGranted) {
//         // If permission is not granted, request permission
//         await Permission.storage.request();
//         status = await Permission.storage.status;

//         // If still not granted, show a message and return
//         if (!status.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Storage permission is required to download PDF.')),
//           );
//           return;
//         }
//       }

//       // Get the application documents directory
//       final directory = await getApplicationDocumentsDirectory();
//       final downloadDirectory = Directory('${directory.path}/Download');

//       if (!await downloadDirectory.exists()) {
//         await downloadDirectory.create(recursive: true);
//       }

//       // Get the file name from the URL
//       final fileName = Uri.parse(widget.url).pathSegments.last;
//       tempFile = File('${downloadDirectory.path}/$fileName');

//       // Check if file already exists (optional)
//       if (!await tempFile!.exists()) {
//         // Show download progress
//         setState(() {
//           isLoading = true;
//         });

//         // Download the file
//         final url = widget.url +"?forcedownload=1&token="+ widget.token;
//         print(url);
//         final response = await http.get(Uri.parse(url));

//         if (response.statusCode == 200) {
//           // Check if the response content type is PDF
       
//             // Save the downloaded file
//             await tempFile!.writeAsBytes(response.bodyBytes);

//             // Validate if the downloaded file is a PDF
//             final fileBytes = await tempFile!.readAsBytes();
//             if (fileBytes[0] == 0x25 && fileBytes[1] == 0x50 && fileBytes[2] == 0x44 && fileBytes[3] == 0x46) {
//               print('Valid PDF file');
//             } else {
//               throw Exception('Downloaded file is not a valid PDF');
//             }
//         } else {
//           throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
//         }
//       }

//       // Hide the progress indicator and show the PDF
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error downloading PDF: $e');
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load PDF. Please try again.')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // Delete the temporary file when the screen is closed
//     if (tempFile != null && tempFile!.existsSync()) {
//       tempFile!.deleteSync();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//         backgroundColor: Theme.of(context).primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Downloading document...'),
//                 ],
//               ),
//             )
//           : tempFile != null
//               ? PDFView(
//                   filePath: tempFile!.path,
//                   enableSwipe: true,
//                   swipeHorizontal: false,
//                   autoSpacing: false,
//                   pageFling: true,
//                   onRender: (pages) => print('PDF rendered with $pages pages'),
//                   onError: (error) => print('Error loading PDF: $error'),
//                   onPageError: (page, error) => print('Page $page: Error $error'),
//                 )
//               : const Center(
//                   child: Text('Failed to load PDF.'),
//                 ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';

// class PdfViewerScreen extends StatefulWidget {
//   final String pdfUrl;
//   final String token;

//    PdfViewerScreen({Key? key, required this.pdfUrl, required String this.token}) : super(key: key);

//   @override
//   _PdfViewerScreenState createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   String? tempFilePath;
//   bool isLoading = true;
//   double downloadProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionAndDownload();
//   }

//   Future<void> _checkPermissionAndDownload() async {
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       _downloadAndDisplayPDF();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage permission is required to download the PDF.')),
//       );
//     }
//   }

//   Future<void> _downloadAndDisplayPDF() async {
//     try {
//       final dir = await getTemporaryDirectory();
//       final filePath = '${dir.path}/temp.pdf';

//       final dio = Dio();
//       await dio.download(
//         widget.pdfUrl,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             setState(() {
//               downloadProgress = received / total;
//             });
//             print('Download progress: ${(downloadProgress * 100).toStringAsFixed(0)}%');
//           }
//         },
//       );

//       if (await File(filePath).exists()) {
//         setState(() {
//           tempFilePath = filePath;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('File download failed.');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

  // @override
  // void dispose() {
  //   if (tempFilePath != null) {
  //     File(tempFilePath!).deleteSync();
  //   }
  //   super.dispose();
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(value: downloadProgress),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Downloading: ${(downloadProgress * 100).toStringAsFixed(0)}%',
//                   ),
//                 ],
//               ),
//             )
//           : PDFView(
//               filePath: tempFilePath,
//             ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:io';


import 'package:elearning/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http; 

class tempfileviewManager {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<Directory> getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory('${directory.path}/temps/');
   

    

    return downloadDirectory;
  }

  static Future<File> _getMetadataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/download_metadata.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

 

 

  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true; // Permission already granted
      } else {
        var status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          return true; // Permission granted after request
        } else {
          // Show a dialog to inform the user about the importance of permission
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text('Storage permission is required to download files. Please grant the permission in the app settings.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    openAppSettings(); // Redirect to app settings
                  },
                  child: const Text('Go to Settings'),
                ),
              ],
            ),
          );
          return false; // Permission denied after request
        }
      }
    } else {
      // Handle other platforms if needed
      return true;
    }
  }

  static Future<String> _calculateMD5(File file) async {
    final bytes = await file.readAsBytes();
    final digest = md5.convert(bytes);
    return digest.toString();
  }

   Future<void> downloadFile(BuildContext context, String url, String token, ) async {
    try {
      
      final hasPermission = await requestStoragePermission(context);
      final hasnotificationpermistion=await requestNotificationPermission(context);
      if (!hasPermission&&!hasnotificationpermistion) {
        print('Storage permission not granted for file download');
        return;
      }
         


      final dio = Dio();
      final downloadDirectory = await getDownloadDirectory();
      final filePath = '${downloadDirectory.path}temp.pdf';

      final file = File(filePath);
    
      

      int notificationId = 0;
     
    

   

      await dio.download(
      url,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) async {
          if (totalBytes != -1) {
            double progress = (receivedBytes / totalBytes) * 100;
            print('Download progress: $progress%');
            // Update notification with download progress
            await _flutterLocalNotificationsPlugin.show(
              notificationId,
              'Downloading /temp.pdf',
              'Download progress: ${progress.toStringAsFixed(0)}%',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'download_channel',
                  'Download',
                  channelDescription: 'Downloading file',
                  importance: Importance.low,
                  priority: Priority.low,
                  ongoing: true,
                  showProgress: true,
                  maxProgress: 100,
                  progress: progress.toInt(),
                ),
              ),
            );
          }
        },
      );
   

      // Verify file checksum
      final downloadedFile = File(filePath);
      final actualChecksum = await _calculateMD5(downloadedFile);

    


    

      // Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: token);
   Navigator.of(context).pushNamed(RouterManger.downloads, arguments: token);

   
    
    } catch (e) {
      print('Error downloading file: $e');
       final downloadDirectory = await getDownloadDirectory();
      final filePath = '${downloadDirectory.path}temp.pdf';
         await _cleanupFailedDownload(filePath, null);
      // Handle error scenarios here
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Error'),
          content: const Text('An error occurred while downloading the file.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

Future<void> _cleanupFailedDownload(String filePath, String? imgPath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      print('Deleted failed file: $filePath');
    }

    if (imgPath != null) {
      final imageFile = File(imgPath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        print('Deleted related image: $imgPath');
      }
    }
  } catch (e) {
    print('Error during cleanup: $e');
  }
}

 




//   Future<void> openNotificationSettings(context) async {
//   if (Theme.of(context).platform == TargetPlatform.android) {
//     // Get the package name
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     String packageName = packageInfo.packageName;

//     // Use platform channel to open the settings
//     const platform = MethodChannel('com.example.elearning.app/settings');
//     try {
//       await platform.invokeMethod('openNotificationSettings', packageName);
//     } on PlatformException catch (e) {
//       print("Failed to open settings: '${e.message}'.");
//     }
//   } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//     // For iOS, this will open the app's settings page
//     const platform = MethodChannel('com.example.elearning.app/settings');
//     await platform.invokeMethod('openAppSettings');
//   }
// }


Future<bool> requestNotificationPermission(context) async {
  // Step 1: Pre-check if notifications are already enabled
  var status = await Permission.notification.status;
  if (status.isGranted) {
    // Notifications are already enabled
    return true;
  }

  // Step 2: Open app settings to allow notifications if not granted
  if (await openNotificationSettings(context)) {
    // Step 3: Post-check the notification permission after returning from settings
    var postStatus = await Permission.notification.status;
    return postStatus.isGranted;
  } else {
    // Failed to open settings or user did not grant permission
    return false;
  }
}

Future<bool> openNotificationSettings(context) async {
  // Check platform
  if (Theme.of(context).platform == TargetPlatform.android) {
    // Android: Open notification settings for the app
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    const platform = MethodChannel('com.example.elearning/settings');
    try {
      await platform.invokeMethod('openNotificationSettings', packageInfo.packageName);
      return true;  // Assuming the user opened the settings
    } on PlatformException {
      return false; // Failed to open settings
    }
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    // iOS: Open the app settings directly
    bool opened = await openAppSettings(); // from permission_handler
    return opened;
  }

  return false;
}
}

