import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/video_player_popup.dart';
import 'package:flutter/material.dart';

class ContinueWatchingScreen extends StatelessWidget {
  final List<VideoItem> videoItems;

  ContinueWatchingScreen({required this.videoItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Learning'),
         backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: videoItems.length,
        itemBuilder: (context, index) {
          final VideoItem videoItem = videoItems[index];
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return VideoPlayerPopup(videoUrl: videoItem.videoUrl);
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      videoItem.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          videoItem.title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          videoItem.description,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Last watched: ${videoItem.lastWatched}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
