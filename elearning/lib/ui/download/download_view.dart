import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class ViewerScreen extends StatefulWidget {
  final String filePath;

  ViewerScreen({required this.filePath});

  @override
  _ViewerScreenState createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;


  @override
  void initState() {
    super.initState();
    final fileExtension = widget.filePath.split('.').last.toLowerCase();

    if (fileExtension == 'mp4' || fileExtension == 'avi' || fileExtension == 'mov') {
      _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
      );
    }
  
  }

  @override
  void dispose() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    }
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.filePath.split('.').last.toLowerCase();

    return Scaffold(
      
      body: Center(
        child: fileExtension == 'pdf'
            ? PDFView(
                filePath: widget.filePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: true,
                onRender: (pages) {
                  print('Document rendered with $pages pages');
                },
                onError: (error) {
                  print('Error loading PDF: $error');
                },
                onPageError: (page, error) {
                  print('Error loading page: $error');
                },
              )
            : fileExtension == 'mp4' || fileExtension == 'avi' || fileExtension == 'mov'
                ?
                 
                 Chewie(
                    controller: _chewieController,
                  )
                : 
                  fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png'
                  ?
                  ImageDisplay(filePath: widget.filePath,)
                  : fileExtension=='pptx'? 
  slides(filePath: widget.filePath,)
  : Center(
                    child: Text('Unsupported file type'),
                  ),


      ),
    );
  }
}

   // For getting the local storage path

class ImageDisplay extends StatefulWidget {
  final String filePath;

  ImageDisplay({required this.filePath});

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    String fileExtension = widget.filePath.split('.').last.toLowerCase();
    if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
      setState(() {
        _imageFile = File(widget.filePath);  // Load the image from the file path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Display")),
      body: Center(
        child: _imageFile != null
            ? Image.file(_imageFile!)  // Display the image
            : Text("No image found."),
      ),
    );
  }
}


class slides extends StatelessWidget {
  final String filePath;

  slides({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Presentation"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _openFile(context, filePath);
          },
          child: const Text('Open PowerPoint'),
        ),
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String filePath) async {
    final result = await OpenFilex.open(filePath);

    String message;

    // Checking the result type to determine if the file was opened or not
    if (result.type == ResultType.done) {
      message = 'File opened successfully!';
    } else {
      message = 'Error: ${result.message}';
    }

    // Display the result in a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


