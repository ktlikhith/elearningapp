import 'dart:async';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/live_event_service.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:elearning/ui/Webview/webview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class LiveSessionPage extends StatefulWidget {
  final String token;

  const LiveSessionPage({Key? key, required this.token}) : super(key: key);

  @override
  _LiveSessionPageState createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
  late Future<List<LiveSession>> _futureData;

  @override
  void initState() {
    super.initState();
    _fetchLiveEventData();
  }

  Future<void> _fetchLiveEventData() async {
    setState(() {
      _futureData = LiveSessionService().fetchLiveSessions(widget.token);
    });
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 4, // Adjust the number of shimmer items as needed
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150, // Adjust the height of the shimmer image placeholder
                  color: Colors.grey[300],
                ),
                SizedBox(height: 12),
                Container(
                  width: 200, // Adjust the width of the text shimmer placeholder
                  height: 22,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(
                  width: 150, // Adjust the width of the text shimmer placeholder
                  height: 22,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Live Event',
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder<List<LiveSession>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect(); // Show shimmer effect while loading
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final List<LiveSession> sessions = snapshot.data!;
              if (sessions.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      //padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                         color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12.0), // Set border radius
                        border: Border.all(color: Color.fromARGB(255, 173, 172, 172)!), // Set border color
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                     
                          Container(
                             
                            width: double.infinity,
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              sessions[index].imgUrl,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          ),
                          ),
                          SizedBox(height: 4),
                          ListTile(
                            title: Text(
                              sessions[index].activityName,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).highlightColor),
                            ),
                           subtitle: Text.rich(
  TextSpan(
    children: [
       TextSpan(
        text: 'Speaker: ',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w700),
      ),
      TextSpan(
        text: '${sessions[index].username}\n',
        style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
      ),
       TextSpan(
        text: 'Start Time: ',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w700),
      ),
      TextSpan(
        text: '${sessions[index].startTime}\n',
        style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
      ),
       TextSpan(
        text: 'Mode: ',style: TextStyle(color: Theme.of(context).hintColor,fontWeight: FontWeight.w700),
      ),
      TextSpan(
        text: '${sessions[index].sessionMod}',
        style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
      ),
    ],
  ),
),

                          ),
                          SizedBox(height: 2),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                if (sessions[index].url != null && sessions[index].url.isNotEmpty) {
                                  String moduleUrl = sessions[index].url;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewPage('Live Event', moduleUrl,widget.token),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                
                                mainAxisSize: MainAxisSize.min, // Ensure the row takes only the minimum required space
                                children: [
                                  Icon(
                                    FontAwesomeIcons.play,
                                    color: Theme.of(context).highlightColor,
                                  ), // Add the Font Awesome icon
                                  SizedBox(width: 8), // Add some space between the icon and text
                                  Text(
                                    'Join Now',
                                    style: TextStyle(color:  Theme.of(context).highlightColor,),
                                  ),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor, 
                                // Set button background color
                              ),
                            ),
                            
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 2, token: widget.token),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
