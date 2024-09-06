import 'package:elearning/services/reward_service.dart';

import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Gamification/reward_section.dart';
import 'package:elearning/ui/Gamification/leaderboard.dart';
import 'package:elearning/ui/Gamification/scratchscreen.dart';
import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<LeaderboardState> _spinWheelKey = GlobalKey<LeaderboardState>();

  @override
  void initState() {
    super.initState();
    _rewardDataFuture = RewardService().getUserRewardPoints(widget.token);
  
  }
  Future<void> _refresh()async{
    // _spinWheelKey.currentState?.refresh();
    setState(() {
         _rewardDataFuture = RewardService().getUserRewardPoints(widget.token);
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
          toolbarHeight: 65,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 0),
            child: Image.asset('assets/gamificatinn/crown.png',),
          ),
          leadingWidth: 40,
          title: FutureBuilder<RewardData>(
            future: _rewardDataFuture,
 builder: (context, snapshot) {
            String pointsText = 'My Points : -';
            if (snapshot.connectionState == ConnectionState.done) {
              final totalPoints = snapshot.data?.totalPoints;
              if (totalPoints != null) {
                pointsText = 'My Points : $totalPoints';
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.5),
                  child: Text(pointsText),
                ),
              ],
            );
          },
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
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
                          child: SpinWheel(token: widget.token, rewardDataFuture: _rewardDataFuture, width: MediaQuery.of(context).size.width * 0.12,onRefresh: _refresh,),
                        ),
                        SizedBox(height: 20),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pushReplacementNamed(RouterManger.Quiz,arguments: widget.token);
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //   backgroundColor: Theme.of(context).secondaryHeaderColor,
                  // ),
                  //         child: Text('QUIZ',style: TextStyle(color: Colors.white),),
                  //       ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ScratchCardScreen(token: widget.token, onRefresh: _refresh),
                  SizedBox(height: 20),
                  
                    
                     Leaderboard(token: widget.token),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3, token: widget.token),
      ),
    );
  }
}
