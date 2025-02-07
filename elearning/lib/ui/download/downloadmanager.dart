// import 'dart:convert';
// import 'dart:io';

// import 'package:elearning/routes/routes.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:crypto/crypto.dart';

// class DownloadManager {
//   static Future<Directory> getDownloadDirectory() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download');

//     if (!await downloadDirectory.exists()) {
//       await downloadDirectory.create(recursive: true);
//     }

//     return downloadDirectory;
//   }

//   static Future<File> _getMetadataFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/download_metadata.json');
//     if (!await file.exists()) {
//       await file.create();
//       await file.writeAsString(jsonEncode([]));
//     }
//     return file;
//   }

// static Future<void> _saveMetadata(String fileName, String url, String checksum, DateTime downloadDate) async {
//   final file = await _getMetadataFile();
//   final content = await file.readAsString();
//   final List<dynamic> metadata = jsonDecode(content);

//   metadata.add({'fileName': fileName, 'url': url, 'checksum': checksum, 'downloadDate': downloadDate.toIso8601String()});

//   await file.writeAsString(jsonEncode(metadata));
// }


//   static Future<List<Map<String, dynamic>>> _loadMetadata() async {
//     final file = await _getMetadataFile();
//     final content = await file.readAsString();
//     final List<dynamic> metadata = jsonDecode(content);
//     return List<Map<String, dynamic>>.from(metadata);
//   }

//   static Future<bool> requestStoragePermission(BuildContext context) async {
//     if (!(await Permission.storage.status.isGranted)) {
//       var status = await Permission.storage.request();
//       if (status.isGranted) {
//         return true; // Permission granted after request
//       } else {
//         // Show a dialog to inform the user about the importance of permission
//         showDialog(
//           context: context,
//           builder: (BuildContext context) => AlertDialog(
//             title: const Text('Permission Required'),
//             content: const Text('Storage permission is required to download files. Please grant the permission in the app settings.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   openAppSettings(); // Redirect to app settings
//                 },
//                 child: const Text('Go to Settings'),
//               ),
//             ],
//           ),
//         );
//         return false; // Permission denied after request
//       }
//     } else {
//       return true; // Permission already granted
//     }
//   }

//   static Future<String> _calculateMD5(File file) async {
//     final bytes = await file.readAsBytes();
//     final digest = md5.convert(bytes);
//     return digest.toString();
//   }

//   static Future<void> downloadFile(BuildContext context, String url, String fileName, String token, {String? expectedChecksum}) async {
//     try {
//       final hasPermission = await requestStoragePermission(context);
//       if (!hasPermission) {
//         print('Storage permission not granted for file download');
//         return;
//       }

//       final dio = Dio();
//       final downloadDirectory = await getDownloadDirectory();
//       final filePath = '${downloadDirectory.path}/$fileName';

//       final file = File(filePath);
//       if (await file.exists()) {
//         // File already exists, show dialog to notify the user
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('File Already Downloaded'),
//             content: const Text('The file is already downloaded.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//         return;
//       }

//       await dio.download(
//         url,
//         filePath,
//         onReceiveProgress: (receivedBytes, totalBytes) {
//           if (totalBytes != -1) {
//             double progress = (receivedBytes / totalBytes) * 100;
//             print('Download progress: $progress%');
//             // Update UI with download progress if needed
//           }
//         },
//       );

//       print('File downloaded to $filePath');

//       // Verify file checksum
//       final downloadedFile = File(filePath);
//       final actualChecksum = await _calculateMD5(downloadedFile);

//       if (expectedChecksum != null && expectedChecksum != actualChecksum) {
//         print('Downloaded file is corrupted');
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Download Failed'),
//             content: const Text('The downloaded file is corrupted.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//         return;
//       }

//       // Save metadata after download
//            DateTime downloadDate = DateTime.now();
// await _saveMetadata(fileName, url, actualChecksum, downloadDate);

//       Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: token);

//       // Example of post-download operation
//       print('Download complete. Showing message to user.');
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Download Complete'),
//           content: const Text('The file has been downloaded successfully.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print('Error downloading file: $e');
//       // Handle error scenarios here
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Download Error'),
//           content: const Text('An error occurred while downloading the file.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   static Future<List<Map<String, dynamic>>> getDownloadedFiles() async {
//     final metadata = await _loadMetadata();
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download');

//     if (await downloadDirectory.exists()) {
//       return metadata;
//     } else {
//       return [];
//     }
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

class DownloadManager {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<Directory> getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory('${directory.path}/Download/');
    final imgdownloadDirectory=Directory('${directory.path}/Download/cimges/');

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
      if(!await imgdownloadDirectory.exists()){
       await imgdownloadDirectory.create(recursive: true);
      }
    }

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

  static Future<void> _saveMetadata(String fileName, String url, String checksum, DateTime downloadDate,String courseName,String Cimg) async {
    final file = await _getMetadataFile();
    final content = await file.readAsString();
    final List<dynamic> metadata = jsonDecode(content);

    metadata.add({'fileName': fileName, 'url': url, 'checksum': checksum, 'downloadDate': downloadDate.toIso8601String(),'CourseName':courseName,'imgurl':Cimg});

print(metadata);
    await file.writeAsString(jsonEncode(metadata));
  }

  static Future<List<Map<String, dynamic>>> _loadMetadata() async {
    final file = await _getMetadataFile();
    final content = await file.readAsString();
    final List<dynamic> metadata = jsonDecode(content);
    return List<Map<String, dynamic>>.from(metadata);
  }

static Future<bool> requestStoragePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    // Handle Android-specific storage permission
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
            content: const Text(
                'Storage permission is required to download files. Please grant the permission in the app settings.'),
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
  } else if (Platform.isIOS) {
    // Handle iOS-specific storage permission
    if (await Permission.photos.isGranted) {
      return true; // Permission already granted
    } else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        return true; // Permission granted after request
      } else {
        // Show a dialog to inform the user about the importance of permission
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                'Photos permission is required to download files. Please grant the permission in the app settings.'),
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
  void userpermission(context)async{
    await requestStoragePermission(context);
      await requestNotificationPermission(context);
  }

   Future<void> downloadFile(BuildContext context, String url, String fileName, String token, String courseNmae,String imgurl,{String? expectedChecksum}) async {
    try {
      print(url);
      final hasPermission = await requestStoragePermission(context);
      final hasnotificationpermistion=await requestNotificationPermission(context);
      if (!hasPermission&&!hasnotificationpermistion) {
        print('Storage permission not granted for file download');
        return;
      }
         


      final dio = Dio();
      final downloadDirectory = await getDownloadDirectory();
      final filePath = '${downloadDirectory.path}$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        // File already exists, show dialog to notify the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('File Already Downloaded'),
            content: const Text('The file is already downloaded and avilable Offline.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      

      int notificationId = 0;
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        'Downloading $fileName',
        'Download started...',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'Download',
            channelDescription: 'Downloading file',
            importance: Importance.low,
            priority: Priority.low,
          ),
        ),
      );
    
  String Cimg = await downloadImage(imgurl,courseNmae,token);  
    print('imgdownloded path $Cimg');
      print('File downloaded to $filePath');

   

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
              'Downloading $fileName',
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

      if (expectedChecksum != null && expectedChecksum != actualChecksum) {
        print('Downloaded file is corrupted');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Download Failed'),
            content: const Text('The downloaded file is corrupted.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Save metadata after download
      DateTime downloadDate = DateTime.now();
      await _saveMetadata(fileName, url, actualChecksum, downloadDate,courseNmae,Cimg);
    

      // Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: token);
   Navigator.of(context).pushNamed(RouterManger.downloads, arguments: token);

      // Example of post-download operation
      print('Download complete. Showing message to user.');
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        'Download Complete',
        'The file $fileName has been downloaded successfully.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'Download',
            channelDescription: 'Downloading file',
            importance: Importance.high,
            priority: Priority.high,
            enableVibration:true,
             icon:'@drawable/eapplogo',
            
          ),
        ),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Complete'),
          content: const Text('The file has been downloaded successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
       final downloadDirectory = await getDownloadDirectory();
      final filePath = '${downloadDirectory.path}$fileName';
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

    // if (imgPath != null) {
    //   final imageFile = File(imgPath);
    //   if (await imageFile.exists()) {
    //     await imageFile.delete();
    //     print('Deleted related image: $imgPath');
    //   }
    // }
  } catch (e) {
    print('Error during cleanup: $e');
  }
}

  static Future<List<Map<String, dynamic>>> getDownloadedFiles() async {
    final metadata = await _loadMetadata();
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory('${directory.path}/Download/');

    if (await downloadDirectory.exists()) {
      return metadata;
    } else {
      return [];
    }
    
  }Future<String> downloadImage(String url, String coursename, String token) async {
  try {
    String imgWithUrl = url;
    print(imgWithUrl);

    // Send a GET request to the URL
    final response = await http.get(Uri.parse(imgWithUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Get the directory to store the downloaded file
      Directory appDocDir = await getDownloadDirectory();
      final baseFilePath = '${appDocDir.path}/cimges/';
      final baseDirectory = Directory(baseFilePath);

      // Ensure the base directory exists
      if (!await baseDirectory.exists()) {
        await baseDirectory.create(recursive: true);
        print('Created base directory: $baseFilePath');
      }

      // Create the course-specific subdirectory
      final imgPath = '$baseFilePath$coursename';
      final courseDirectory = Directory(imgPath);

      if (!await courseDirectory.exists()) {
        await courseDirectory.create(recursive: true);
        print('Created course directory: $imgPath');
      }

      // Define the full file path for the image
      final filePath = '$imgPath/image.png'; // You can adjust the file name as needed.

      // Write the file to the specified path
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Image downloaded to: $filePath');
      return filePath;
    } else {
      throw Exception("Failed to download image. Status code: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error downloading image: $e");
  }
}


 static Future<Directory> getDownloadDirectoryforimg(String courseName) async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory('${directory.path}/Download/');

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    return downloadDirectory;
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
