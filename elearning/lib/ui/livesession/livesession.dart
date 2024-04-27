import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/live_event.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';

class LiveSessionPage extends StatefulWidget {
  final String token;

  const LiveSessionPage({Key? key, required this.token}) : super(key: key);

  @override
  _LiveSessionPageState createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
   _fetchLiveEventData();
}

Future<void> _fetchLiveEventData() async {
  setState(() {
    _futureData = LiveEventService().fetchLiveEvent(widget.token);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Live Session',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,color: Colors.white,
          ),
        ),
           leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.homescreen,arguments: widget.token);
          },
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          // } else if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(data['imageUrl']), // Replace VideoPlayerScreen with Image
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Speaker: ${data['speakerName']}\nDuration: ${data['duration']}\nMode: ${data['mode']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Session Address: ${data['sessionAddress']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 2, token: widget.token),
    );
  }
}

