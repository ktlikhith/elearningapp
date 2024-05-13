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
// Import the RankLevel widget


class _GamificationPageState extends State<GamificationPage> {
  late Future<RewardData> _rewardDataFuture;

  @override
  void initState() {
    super.initState();
    _rewardDataFuture = RewardService().getUserRewardPoints(widget.token);
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
          title: FutureBuilder<RewardData>(
            future: _rewardDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final totalPoints = snapshot.data!.totalPoints;
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
                      totalPoints,
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink(); // Hide the title while loading
              }
            },
          ),
         
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              children: [
               
                RewardSection(token: widget.token, rewardDataFuture: _rewardDataFuture),
               
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SpinWheel(token: widget.token, rewardDataFuture: _rewardDataFuture, width: MediaQuery.of(context).size.width * 0.12,),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(RouterManger.Quiz);
                        },
                        child: Text('QUIZ'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ScratchCardScreen(token: widget.token),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Leaderboard(token: widget.token),
                ),
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
