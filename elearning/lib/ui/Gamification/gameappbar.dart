import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Gamification/reward_section.dart';
import 'package:elearning/ui/Gamification/leaderboard.dart';
import 'package:elearning/ui/Gamification/scratchscreen.dart';
import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GamificationPage extends StatefulWidget {
  final String token;

  GamificationPage({Key? key, required this.token}) : super(key: key);

  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  late Future<Map<String, dynamic>> _rewardDataFuture;

  @override
  void initState() {
    super.initState();
    _rewardDataFuture = Rewardservice().getUserRewardPoints(widget.token);
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
          toolbarHeight: 65,
          backgroundColor: Theme.of(context).primaryColor,
          title: FutureBuilder<Map<String, dynamic>>(
            future: _rewardDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading points');
              } else {
                final totalPoints = snapshot.data!['total_points'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 82.0, vertical: 1.5),
                      child: Text(
                        'My Points',
                      ),
                    ),
                    Text(
                      totalPoints?.toString() ?? '0',
                    ),
                  ],
                );
              }
            },
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RewrdSection(token: widget.token),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Color.fromARGB(255, 232, 231, 231),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SpinWheel1(), // Include SpinWheel1 here
                          ],
                        ),
                      ),
                      VerticalDivider(thickness: 1, color: Colors.black),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 30,
                              child: FaIcon(FontAwesomeIcons.trophy, size: 40, color: Colors.white),
                            ),
                            Text('Redemption Zone'),
                            ElevatedButton(
                              onPressed: () {
                                // Implement points redeem functionality
                              },
                              child: Text('Points Redeem'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Implement gift rewards functionality
                              },
                              child: Text('Gift Rewards'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ScratchCardScreen(token: widget.token),
                SizedBox(height: 20),
                leaderboard(token: widget.token),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3, token: widget.token),
      ),
    );
  }
}
