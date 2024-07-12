import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String courseVideourl;

  VideoPlayerScreen({required this.courseVideourl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late Widget _playerWidget;
  late VideoPlayerController _videoController;
  late bool _isPlaying = true;
  late bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    
   
  }

  void _initializePlayer() {
    if (widget.courseVideourl.contains('youtube.com') ||
        widget.courseVideourl.contains('youtu.be')) {
      _playerWidget = YoutubePlayer(
        controller: YoutubePlayerController(
          
          initialVideoId: YoutubePlayer.convertUrlToId(widget.courseVideourl)!,
          
          flags: YoutubePlayerFlags(autoPlay: true, mute: false),
        ),
        
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          // await Future.delayed(Duration(milliseconds: 1000));
          
      setState(() {});
    
    
        },
      );
    } else {
      print('hoi');
      _videoController = VideoPlayerController.network(widget.courseVideourl);
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
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.fullscreen),
              onPressed: () {
                _toggleFullScreen();
              },
            ),
          ),
        ],
      );
      _videoController.initialize().then((_) {
        setState(() {});
      });
    }
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  void dispose() {
    if (widget.courseVideourl.contains('youtube.com') ||
        widget.courseVideourl.contains('youtu.be')) {
      final YoutubePlayerController controller =
          (_playerWidget as YoutubePlayer).controller;
      controller.pause();
      controller.dispose();
    } else {
      _videoController.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: Stack(
        children: [
          Center(
            child: _playerWidget,
          ),
          if (!_isFullScreen) // Show close button only when not in full screen
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: () {
                  if (_isFullScreen) {
                    _toggleFullScreen();
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
