import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Dashboard/video_player_popup.dart';
import 'package:flutter/material.dart';

class CustomDashboardWidget extends StatefulWidget {
  final String token;

  CustomDashboardWidget({Key? key, required this.token}) : super(key: key);

  @override
  _CustomDashboardWidgetState createState() => _CustomDashboardWidgetState();
}

class _CustomDashboardWidgetState extends State<CustomDashboardWidget> {
  List<VideoItem> _videoItems = [];

  @override
  void initState() {
    super.initState();
    _fetchVideoData(widget.token);
  }

  Future<void> _fetchVideoData(String token) async {
    // Simulated API response
    final jsonData = {
      "videos": [
        {
          "title": "Video 1",
          "image": "https://via.placeholder.com/150",
          "last_watched": "2 hours ago",
          "description": "Description for Video 1",
          "videourl": "https://www.youtube.com/watch?v=BBAyRBTfsOU",
        },
        {
          "title": "Video 2",
          "image": "https://via.placeholder.com/150",
          "last_watched": "1 day ago",
          "description": "Description for Video 2",
          "videourl": 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        },
         {
          "title": "Video 3",
          "image": "https://via.placeholder.com/150",
          "last_watched": "3 days ago",
          "description": "Description for Video 3",
          "videourl": 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        },
        {
          "title": "Video 4",
          "image": "https://via.placeholder.com/150",
          "last_watched": "3 days ago",
          "description": "Description for Video 4",
          "videourl": 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        },
         
      ]
    };

    // Process the JSON data
    final videoList = jsonData['videos'] as List<Map<String, dynamic>>?;

    setState(() {
      _videoItems = videoList
          ?.map<VideoItem>((item) => VideoItem(
                title: item['title'] ?? '',
                imageUrl: item['image'] ?? '',
                lastWatched: item['last_watched'] ?? '',
                description: item['description'] ?? '',
                videoUrl: item['videourl'] ?? '',
              ))
          .toList() ?? [];
    });
  }


Widget _buildSection(BuildContext context, VideoItem video) {
  final cardWidth = 120.0; // Width of each card

  return Padding(
    padding: EdgeInsets.only(right: 10.0), // Adjust the spacing as needed
    child: Container(
      width: cardWidth,
      color: Color.fromARGB(255, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return VideoPlayerPopup(videoUrl: video.videoUrl);
                },
              );
            },
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(video.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.play_circle_fill),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return VideoPlayerPopup(videoUrl: video.videoUrl);
                      },
                    );
                  },
                  color: Colors.white,
                  iconSize: 50.0,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.white, // Adjust as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    // Add your info icon functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Add your option icon functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // Assuming you have some styling for your dashboard container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
    Navigator.of(context).pushNamed(
      RouterManger.continuescreen,
      arguments: _videoItems, // Pass _videoItems to the next screen
    );},
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _videoItems.map((video) {
                return SizedBox(
                  width: screenWidth > 3 * 120 ? 120 : screenWidth / 3,
                  child: _buildSection(context,video),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem {
  final String title;
  final String imageUrl;
  final String lastWatched;
  final String description;
  final String videoUrl; // Add this property

  VideoItem({
    required this.title,
    required this.imageUrl,
    required this.lastWatched,
    required this.description,
    required this.videoUrl, // Add this property to the constructor
  });
}

