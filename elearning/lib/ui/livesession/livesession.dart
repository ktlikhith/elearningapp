import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/live_event_service.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            'Live Session',
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
            },
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder<List<LiveSession>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final List<LiveSession> sessions = snapshot.data!;
              return ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the session URL when tapped
                      _launchURL(sessions[index].url);
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.network(sessions[index].imgUrl), // Image displayed above other content
                          SizedBox(height: 8), // Add some spacing between image and other content
                          ListTile(
                            title: Text(sessions[index].activityName),
                            subtitle: Text('Speaker: ${sessions[index].username}\nStart Time: ${sessions[index].startTime}\nMode: ${sessions[index].sessionMod}'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 2, token: widget.token),
      ),
    );
  }

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
