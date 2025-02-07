import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoUrl;

  YouTubePlayerScreen({required this.videoUrl});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    print(widget.videoUrl);
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
     _controller = YoutubePlayerController.fromVideoId(
  videoId: videoId!,
  autoPlay: true,
  params: const YoutubePlayerParams(showFullscreenButton: true,strictRelatedVideos:true),
);

  }
  

  @override
  void dispose() async{
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.top,SystemUiOverlay.bottom]);
      await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.close();
    super.dispose();
  }

  
  @override
Widget build(BuildContext context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
  
  child:  Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: isPortrait ? MediaQuery.of(context).size.height * 0.35 : 0),
            child: YoutubePlayerScaffold(
              controller: _controller,
              aspectRatio: 16 / 9,
              builder: (BuildContext context, Widget player) {
                return Column(
                  children: [
                    player,
                  ],
                );
              },
            ),
          ),
          if (isPortrait)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  
  
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                
                  child: Text(
                    'Close',
                    style: TextStyle(color:Colors.red, fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  ),
  );
  
}

}