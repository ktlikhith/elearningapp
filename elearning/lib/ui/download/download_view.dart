import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
                ? Chewie(
                    controller: _chewieController,
                  )
                : Center(
                    child: Text('Unsupported file type'),
                  ),
      ),
    );
  }
}
