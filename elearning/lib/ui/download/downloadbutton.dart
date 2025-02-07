import 'dart:io';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart'; // For getting the download directory

class DownloadButton extends StatefulWidget {
  final dynamic module;
  final String token;
  final String courseName;
  final String imgurl;

  const DownloadButton({
    Key? key,
    required this.module,
    required this.token,
    required this.courseName,
    required this.imgurl,
  }) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
  }

  Future<void> _checkIfFileExists() async {
    if (widget.module['contents'] != null && widget.module['contents'].isNotEmpty) {
      final content = widget.module['contents'][0];
      if (content['filename'] != null) {
        final filePath = await _getFilePath(content['filename']);
        final file = File(filePath);

        setState(() {
          isDownloaded = file.existsSync();
        });
      }
    }
  }

  Future<String> _getFilePath(String fileName) async {
    final downloadDirectory = await DownloadManager.getDownloadDirectory();
    return '${downloadDirectory.path}/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    if (isDownloaded) {
      return IconButton(
        onPressed: (){
        Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);
        },
        icon:   Icon(
          
          FontAwesomeIcons.checkToSlot,
          color: Colors.green,
          size: 16.5,
        ),
      );
    }

    return isDownloading
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          )
        : IconButton(
            icon: const FaIcon(FontAwesomeIcons.download, color: Colors.black, size: 16.5),
            onPressed: () async {
              if (widget.module['contents'] != null && widget.module['contents'].isNotEmpty) {
                final content = widget.module['contents'][0];
                if (content['fileurl'] != null && content['filename'] != null) {
                  setState(() {
                    isDownloading = true;
                  });

                  String getDownloadUrlWithToken(String filePath, String token) {
                    return '$filePath&token=$token';
                  }

                  String fileurl = getDownloadUrlWithToken(content['fileurl'], widget.token);
                  DownloadManager dm = DownloadManager();

                  await dm.downloadFile(
                    context,
                    fileurl,
                    content['filename'],
                    widget.token,
                    widget.courseName,
                    widget.imgurl,
                  );

                  await _checkIfFileExists(); // Check if the file exists after download

                  setState(() {
                    isDownloading = false;
                  });
                }
              }
            },
          );
  }
}
