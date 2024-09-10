import 'dart:convert';
import 'dart:io';

import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/download/download_view.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class CourseDownloaded extends StatefulWidget {
  final String courseName;
  final List<Map<String, dynamic>> files;
  String token;

  CourseDownloaded({
    required this.courseName,
    required this.files,
    required this.token,
  });

  @override
  State<CourseDownloaded> createState() => _CourseDownloadedState();
}

class _CourseDownloadedState extends State<CourseDownloaded> {
  List<Map<String, dynamic>> _currentFiles = [];

  @override
  void initState() {
    super.initState();
    _currentFiles = List.from(widget.files); // Clone the files list to keep state mutable
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: widget.token);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon:  Icon(Icons.arrow_back, color: Theme.of(context).highlightColor),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: widget.token,result: true);
              
            },
          ),
          title: Text(widget.courseName),
        ),
        body: _currentFiles.isEmpty
            ? Center(
                child: Text('No files available.'),
              )
            : ListView.builder(
                itemCount: _currentFiles.length,
                itemBuilder: (context, index) {
                  final file = _currentFiles[index];
                  final fileName = file['fileName'];
                  final filePath = file['filePath'];
                  final downloadDate = file['downloadDate'] ?? 'Unknown Date';

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Dismissible(
                      key: Key(fileName),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteFile(context,filePath, fileName);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: (){
                      ViewerScreen(filePath: filePath,);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 0.0),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey),
                            color: Theme.of(context).hintColor.withOpacity(0.8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        _getIconForFile(filePath),
                                        size: 44.0,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        '$fileName\n',
                                        style:  TextStyle(fontSize: 16.0,color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Info icon to show file details
                                    Column(
                                      children: [
                                        IconButton(
                                          icon:  Icon(Icons.info_outline, color: Theme.of(context).cardColor),
                                          onPressed: () => _showFileInfo(context, filePath, downloadDate),
                                        ),
                                          IconButton(
                                      icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 243, 33, 33)),
                                      onPressed: () => _deleteFile(context,filePath, fileName),
                                    ),
                                      ],
                                    ),
                                   
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _deleteFile(context,String filePath, String fileName) async {
    try {
      // Delete the actual file from the system
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }

      // Remove the file from the current list
      setState(() {
        _currentFiles.removeWhere((file) => file['fileName'] == fileName);
      });
await _updateMetadata(fileName);
      // If no files remain, pop the context
      if (_currentFiles.isEmpty) {
        Navigator.of(context).pushReplacementNamed(RouterManger.downloads, arguments: widget.token,result: true);
      }

      // Update the metadata file (implement this method if not done already)
    

    } catch (e) {
      print("Error deleting file: $e");
    }
  }
  

  Future<void> _updateMetadata(String fileName) async {
    final files = await DownloadManager.getDownloadedFiles();
    final metadataFile = await _getMetadataFile();
    final List<dynamic> metadata = jsonDecode(await metadataFile.readAsString());
    metadata.removeWhere((entry) => entry['fileName'] == fileName);
    await metadataFile.writeAsString(jsonEncode(metadata));
  }

  Future<File> _getMetadataFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/download_metadata.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

  void _showFileInfo(BuildContext context, String filePath, String date) {
    final fileSize = _getFileSize(filePath);
    final fileExtension = _getFileExtension(filePath);

    DateTime parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String formattedTime = DateFormat('hh:mm a').format(parsedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File Information',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  Text('Size: $fileSize'),
                  const SizedBox(height: 8.0),
                  Text('Format: $fileExtension'),
                  const SizedBox(height: 8.0),
                  Text('Downloaded Date: $formattedDate'),
                  const SizedBox(height: 8.0),
                  Text('Downloaded Time: $formattedTime'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getFileSize(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      final bytes = file.lengthSync();
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return 'Unknown size';
  }

  String _getFileExtension(String filePath) {
    return extension(filePath).replaceAll('.', '').toUpperCase();
  }

  IconData _getIconForFile(String filePath) {
    final fileExtension = extension(filePath).toLowerCase();
    switch (fileExtension) {
      case '.mp4':
      case '.avi':
      case '.mov':
        return Icons.play_circle_fill;
      case '.pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.insert_drive_file;
    }
  }
}
