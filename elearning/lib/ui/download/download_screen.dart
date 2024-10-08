

// import 'dart:convert';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/ui/download/download_view.dart';
// import 'package:elearning/ui/download/downloadmanager.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class DownloadsScreen extends StatefulWidget {
//   final String token;

//   const DownloadsScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   _DownloadsScreenState createState() => _DownloadsScreenState();
// }

// class _DownloadsScreenState extends State<DownloadsScreen> {
//   List<Map<String, dynamic>> _files = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadDownloadedFiles();
//   }

//   Future<void> _loadDownloadedFiles() async {
//     final files = await DownloadManager.getDownloadedFiles();
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download');

//     final List<Map<String, dynamic>> fileList = [];
//     for (var file in files) {
//       final filePath = join(downloadDirectory.path, file['fileName']);
//       fileList.add({
//         'fileName': file['fileName'],
//         'url': file['url'],
//         'filePath': filePath,
//         'downloadDate': file['downloadDate'], // Assuming 'downloadDate' is in the file data
//       });
//     }

//     setState(() {
//       _files = fileList;
//     });
//   }

//   void _reDownloadFile(BuildContext context, String url, String fileName,String courseName) async {
//     await DownloadManager.downloadFile(context, url, fileName, widget.token,courseName);
//     _loadDownloadedFiles(); // Refresh the file list after re-download
//   }

//   Future<void> _deleteFile(String filePath, String fileName) async {
//     File(filePath).deleteSync();
//     final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download');

//     // Delete the metadata for the file
//     final metadataFile = await _getMetadataFile();
//     final List<dynamic> metadata = jsonDecode(await metadataFile.readAsString());
//     metadata.removeWhere((entry) => entry['fileName'] == fileName);
//     await metadataFile.writeAsString(jsonEncode(metadata));

//     // Remove the file from the list of downloaded files
//     setState(() {
//       _files.removeWhere((file) => file['fileName'] == fileName);
//     });
//   }

//   Future<File> _getMetadataFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/download_metadata.json');
//     if (!await file.exists()) {
//       await file.create();
//       await file.writeAsString(jsonEncode([]));
//     }
//     return file;
//   }


// void _showFileInfo(BuildContext context, String filePath, String date) {
//   final fileSize = _getFileSize(filePath);
//   final fileExtension = _getFileExtension(filePath);

//   // Parse the date string
//   DateTime parsedDate = DateTime.parse(date);
//   String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
//   String formattedTime = DateFormat('hh:mm a').format(parsedDate); // 12-hour format with AM/PM

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true, // Allow the bottom sheet to take full height
//     builder: (context) {
//       return Container(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'File Information',
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12.0),
//                 Text('Size: $fileSize'),
//                 const SizedBox(height: 8.0),
//                 Text('Format: $fileExtension'),
//                 const SizedBox(height: 8.0),
//                 Text('Downloaded Date: $formattedDate'),
//                 const SizedBox(height: 8.0),
//                 Text('Downloaded Time: $formattedTime'),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//   void _showMoreOptions(BuildContext context, String fileName, String filePath, String downloadDate) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.delete),
//               title: const Text('Delete'),
//               onTap: () {
//                 _deleteFile(filePath, fileName);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.info),
//               title: const Text('Details'),
//               onTap: () {
//                 _showFileInfo(context, filePath, downloadDate);
                
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Downloads'),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//           // Navigator.of(context).pushReplacementNamed(RouterManger.morescreen, arguments: widget.token);
//           Navigator.pop(context,true);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _files.isEmpty
//                   ? const Center(child: Text('No downloaded files found.'))
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: _files.length,
//                       itemBuilder: (context, index) {
//                         final file = _files[index];
//                         final fileName = file['fileName'];
//                         final url = file['url'];
//                         final filePath = file['filePath'];
//                         final downloadDate = file['downloadDate'] ?? 'Unknown Date'; // Assuming 'downloadDate' is in the file data

//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ViewerScreen(filePath: filePath),
//                               ),
//                             );
//                           },
//                           child: Dismissible(
//                             key: Key(fileName), // Ensure each item has a unique key
//                             direction: DismissDirection.endToStart,
//                             onDismissed: (direction) {
//                               _deleteFile(filePath, fileName);
//                             },
//                             background: Container(
//                               alignment: Alignment.centerRight,
//                               color: Colors.red,
//                               child: const Icon(Icons.delete, color: Colors.white),
//                             ),
//                             child: Container(
//                               margin: const EdgeInsets.only(bottom: 16.0),
//                               padding: const EdgeInsets.all(16.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 border: Border.all(color: Colors.grey),
//                               ),
//                               child: Row(
//                                 children: [
//                                   // Icon & File Name
//                                   Expanded(
//                                     flex: 3, // Icon takes 3 parts of available space
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           _getIconForFile(filePath),
//                                           size: 48.0,
//                                           color: const Color.fromARGB(255, 237, 23, 23), // Adjust color as needed
//                                         ),
//                                         const SizedBox(width: 8.0),
//                                         Expanded(
//                                           child: Text(
//                                             '$fileName\n',
//                                             style: const TextStyle(fontSize: 16.0, ),
//                                             maxLines: 2, // Ensure filename doesn't overflow
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // More Button
//                                   Expanded(
//                                     flex: 1, // More button takes 1 part of available space
//                                     child: IconButton(
//                                       icon: const Icon(Icons.more_vert, color: Colors.black),
//                                       onPressed: () => _showMoreOptions(context, fileName, filePath, downloadDate),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getIconForFile(String filePath) {
//     final fileExtension = extension(filePath).toLowerCase();
//     switch (fileExtension) {
//       case '.mp4':
//       case '.avi':
//       case '.mov':
//         return Icons.play_circle_fill;
//       case '.pdf':
//         return Icons.picture_as_pdf;
//       default:
//         return Icons.insert_drive_file;
//     }
//   }

//   String _getFileSize(String filePath) {
//     final file = File(filePath);
//     if (file.existsSync()) {
//       final bytes = file.lengthSync();
//       return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
//     }
//     return 'Unknown size';
//   }

//   String _getFileExtension(String filePath) {
//     return extension(filePath).replaceAll('.', '').toUpperCase();
//   }
// }




import 'dart:async';
import 'dart:convert';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/My_learning/startcourse_content.dart';
import 'package:elearning/ui/download/download_view.dart';
import 'package:elearning/ui/download/downloadedcontents.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadsScreen extends StatefulWidget {
  final String token;

  const DownloadsScreen({Key? key, required this.token}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<Map<String, dynamic>> _files = [];

  @override
void initState() {
  super.initState();
  _loadDownloadedFiles();
  Timer.periodic(Duration(seconds: 1), (Timer timer) {
    _loadDownloadedFiles();
  });
}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

void _navigateToDownloadcontentScreen(Context,coursename,filelist) async {
  final result = await  Navigator.of(Context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CourseDownloaded(
                            courseName: coursename,
                            files: filelist,
                            token: widget.token,
                          ),
                        )
                        
                      );

  if (result == true) {
    setState(() {
      // Refresh the data if result is true
      _loadDownloadedFiles();
    });
  }
}
 

// Future<void> _loadDownloadedFiles() async {
//   final files = await DownloadManager.getDownloadedFiles();
//   final directory = await getApplicationDocumentsDirectory();
//     final downloadDirectory = Directory('${directory.path}/Download/');
  
//   final Map<String, List<Map<String, dynamic>>> groupedFiles = {};

//   for (var file in files) {
//     final courseName = file['CourseName']; // Assume courseName is in the file data
//   //  final cimgpath=file['imgurl'];
//    // print(cimgpath);

//     final filePath = join(downloadDirectory.path, file['fileName']);
//     final fileData = {
//       'fileName': file['fileName'],
//       'url': file['url'],
//       'filePath': filePath,
//       'downloadDate': file['downloadDate'],
//       'imgurl':file['imgurl'],
//     };
//     print(fileData);

//     if (!groupedFiles.containsKey(courseName)) {
//       groupedFiles[courseName] = [];
//     }
//     groupedFiles[courseName]?.add(fileData);
//   }

//   setState(() {
//   _files = groupedFiles.entries.map((e) {
//     // Assuming each file contains 'imgurl', you can extract it from the first file in the list.
//     String? imgurl;
//     if (e.value.isNotEmpty && e.value[0].containsKey('imgurl')) {
//       imgurl = e.value[0]['imgurl'];
//     }

//     return {
//       'courseName': e.key,
//       'files': e.value,
//       'imgurl': imgurl, // Add imgurl to the map
//     };
//   }).toList();
// });

// }


  // void _reDownloadFile(BuildContext context, String url, String fileName,String courseName) async {
  //   await DownloadManager.downloadFile(context, url, fileName, widget.token,courseName);
  //   _loadDownloadedFiles(); // Refresh the file list after re-download
  // }




  Future<File> _getMetadataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/download_metadata.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

Future<List<Map<String, dynamic>>> _loadDownloadedFiles() async {
  final files = await DownloadManager.getDownloadedFiles();
  final directory = await getApplicationDocumentsDirectory();
  final downloadDirectory = Directory('${directory.path}/Download/');

  final Map<String, List<Map<String, dynamic>>> groupedFiles = {};

  for (var file in files) {
    final courseName = file['CourseName'];
    final filePath = join(downloadDirectory.path, file['fileName']);
    final fileData = {
      'fileName': file['fileName'],
      'url': file['url'],
      'filePath': filePath,
      'downloadDate': file['downloadDate'],
      'imgurl': file['imgurl'],
    };

    if (!groupedFiles.containsKey(courseName)) {
      groupedFiles[courseName] = [];
    }
    groupedFiles[courseName]?.add(fileData);
  }

  return groupedFiles.entries.map((e) {
    String? imgurl;
    if (e.value.isNotEmpty && e.value[0].containsKey('imgurl')) {
      imgurl = e.value[0]['imgurl'];
    }
    return {
      'courseName': e.key,
      'files': e.value,
      'imgurl': imgurl,
    };
  }).toList();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Downloads'),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadDownloadedFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No downloaded files.'));
        } else {
          final files = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: files.map((courseData) {
                  final courseName = courseData['courseName'] as String;
                  final cimg = courseData['imgurl'];
                  final fileList = courseData['files'] as List<Map<String, dynamic>>;

                  return GestureDetector(
                    onTap: () {
                     _navigateToDownloadcontentScreen(context,courseName,fileList);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.95,
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                              cimg != null
                              ? Image.file(
                                  File(cimg),
                                  width: MediaQuery.of(context).size.width*0.325,
                                  height: 70,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/images/coursedefaultimg.jpg',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),),
                                
                                 Padding(
                                   padding: const EdgeInsets.only(left: 10.0),
                                   child: Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                     child: Text(
                                                                     courseName,
                                                                     overflow: TextOverflow.clip,
                                                                     maxLines: 2,
                                                                     style: TextStyle(
                                                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).highlightColor,
                                                                     ),
                                                                   ),
                                   ),
                                 ),
                            ],
                          ),
                         
                       
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    ),
  );
}


 

  String _getFileExtension(String filePath) {
    return extension(filePath).replaceAll('.', '').toUpperCase();
  }
}
