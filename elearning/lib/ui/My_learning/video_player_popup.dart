import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPopup extends StatefulWidget {
  final String course_videourl;

  VideoPlayerPopup( {required this.course_videourl});

  @override
  _VideoPlayerPopupState createState() => _VideoPlayerPopupState();
}

class _VideoPlayerPopupState extends State<VideoPlayerPopup> {
  late Widget _playerWidget;
  late VideoPlayerController _videoController;
  late bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.course_videourl.contains('youtube.com') ||
        widget.course_videourl.contains('youtu.be')) {
      _playerWidget = YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.course_videourl)!,
          flags: YoutubePlayerFlags(autoPlay: true, mute: false),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      );
    } else {
      _videoController = VideoPlayerController.network(widget.course_videourl);
      _playerWidget = Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                if (_isPlaying) {
                  _videoController.pause();
                } else {
                  _videoController.play();
                }
                _isPlaying = !_isPlaying;
              });
            },
          ),
        ],
      );
      _videoController.initialize().then((_) {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    if (widget.course_videourl.contains('youtube.com') ||
        widget.course_videourl.contains('youtu.be')) {
      final YoutubePlayerController controller =
          (_playerWidget as YoutubePlayer).controller;
      controller.pause();
      controller.dispose();
    } else {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
  backgroundColor: Colors.transparent, 
  elevation: 0, // Remove elevation
  contentPadding: EdgeInsets.zero, // Remove content padding
  content: SizedBox(
    width: MediaQuery.of(context).size.width, // Set width to screen width
    child: SingleChildScrollView(child: _playerWidget),
  ),
  
  actions: <Widget>[
    TextButton(
      onPressed: () {
        // Dispose video players when closing the dialog
        if (widget.course_videourl.contains('youtube.com') ||
            widget.course_videourl.contains('youtu.be')) {
          final YoutubePlayerController controller =
              (_playerWidget as YoutubePlayer).controller;
          controller.pause();
          controller.dispose();
        } else {
          _videoController.dispose();
        }
        Navigator.of(context).pop();
      },
      child: Text('Close'),
    ),
  ],
);

  }
}
