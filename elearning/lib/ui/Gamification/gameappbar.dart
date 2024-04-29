import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Gamification/leaderboard.dart';
import 'package:elearning/ui/Gamification/scratchscreen.dart';
import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';

class GamificationPage extends StatefulWidget {
  final String token;

  GamificationPage({Key? key, required this.token}) : super(key: key);

  @override
  _GamificationPageState createState() => _GamificationPageState();
}

class _GamificationPageState extends State<GamificationPage> {
  Widget buildPointsCategory(String title, IconData icon) {
    return Container(
      height: 120,
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        color: Color.fromARGB(255, 255, 252, 252),
        border: Border.all(
          color: const Color.fromARGB(255, 227, 236, 227), // Green border color
          width: 2.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: Color.fromARGB(255, 10, 10, 10)),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Color.fromARGB(255, 9, 9, 9), fontSize: 15),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Limiting to 2 lines to prevent overflow
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: SizedBox(height: 4),
                  ),
                  Text(
                    '250', // Replace with actual point value
                    style: TextStyle(color: Color.fromARGB(255, 5, 5, 5), fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          toolbarHeight: 65,
          backgroundColor: Theme.of(context).primaryColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 82.0, vertical: 1.5),
                child: Text(
                  'My Points',
                 
                ),
              ),
              Text(
                '1000', // Replace with actual points value
                
              ),
            ],
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        buildPointsCategory('Login Points', FontAwesomeIcons.laptopMedical),
                        buildPointsCategory('Daily Quiz Points', FontAwesomeIcons.brain),
                        buildPointsCategory('Spin Wheel Points', FontAwesomeIcons.dharmachakra),
                        buildPointsCategory('Reward Received', FontAwesomeIcons.gifts),
                      ],
                    ),
                  ),
                ),
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
