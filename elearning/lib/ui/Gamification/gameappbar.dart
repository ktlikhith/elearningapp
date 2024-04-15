import 'dart:ui';

import 'package:elearning/ui/Gamification/spinwheel1.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class GamificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Points',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24,),
            ),
            Text(
              '1000', // Replace with actual points value
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40,width: 50,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      buildPointsCategory('Login Points', Icons.login,Color(0xFF512DA8),    Color(0xFFD500F9) ),
                      buildPointsCategory('Daily Quiz Points', Icons.quiz, Color.fromRGBO(11, 114, 12, 1),Color.fromARGB(255, 75, 199, 79)),
                      buildPointsCategory('Spin Wheel Points', Icons.casino, Color.fromARGB(255, 255, 225, 0),Color.fromARGB(255, 245, 251, 56)),
                      buildPointsCategory('Reward Received', Icons.card_giftcard, Color.fromRGBO(4, 7, 145, 1),Color.fromARGB(255, 49, 52, 217)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          SpinWheel1(), // Include SpinWheel1 here
                          Text('Spin the wheel and luck your chance to get points benefit and redeem.'),
                         NeoPopTiltedButton(
  isFloating: true,
  onTapUp: () {},
  decoration: NeoPopTiltedButtonDecoration(
    color:Color(0xFFD500F9),
    plunkColor: Color(0xFFD500F9),
    shadowColor: Color.fromRGBO(36, 36, 36, 1),
    showShimmer: true,

 
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
    child: Text('SPIN'),
  ),
),

                        ],
                      ),
                    ),
                    VerticalDivider(thickness: 1, color: Colors.black),
                    Expanded(
                      flex: 1,
                      child: Column(
                        
                        children: [
                          
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
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
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Available scratch cards:', style: TextStyle(fontSize: 16)),
                    Text('3/3'), // Replace with actual available scratch cards count
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildScratchCard(),
                        buildScratchCard(),
                        buildScratchCard(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Leader Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    buildLeaderBoard(), // Call the buildLeaderBoard method here
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3),
    );
  }

Widget buildPointsCategory(String title, IconData icon, Color color1, Color color2) {
  return Container(
    height: 120,
    width: 120,
    margin: EdgeInsets.symmetric(horizontal: 8),
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
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
        color1, // Replace with your desired gradient colors
        color2, // Example colors used here
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Color.fromARGB(255, 241, 236, 236)),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        Text(
          '500', // Replace with actual point value
          style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}




  Widget buildScratchCard() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: FaIcon(FontAwesomeIcons.trophy, size: 50, color: Colors.white),
      ),
    );
  }

  Widget buildLeaderBoard() {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FractionColumnWidth(0.1),
        1: FractionColumnWidth(0.3),
        2: FractionColumnWidth(0.2),
        3: FractionColumnWidth(0.4),
      },
      children: [
        TableRow(
          children: [
            TableCell(child: Center(child: Text('#'))),
            TableCell(child: Center(child: Text('Name'))),
            TableCell(child: Center(child: Text('Rank'))),
            TableCell(child: Center(child: Text('Department'))),
          ],
        ),
        // Add dynamic data for leader board rows here
        buildLeaderBoardRow('1', 'John Doe', '1', 'Engineering'),
        buildLeaderBoardRow('2', 'Jane Smith', '2', 'Marketing'),
        buildLeaderBoardRow('3', 'Mike Johnson', '3', 'Finance'),
      ],
    );
  }

  TableRow buildLeaderBoardRow(String slNo, String name, String rank, String department) {
    return TableRow(
      children: [
        TableCell(child: Center(child: Text(slNo))),
        TableCell(child: Center(child: Text(name))),
        TableCell(child: Center(child: Text(rank))),
        TableCell(child: Center(child: Text(department))),
      ],
    );
  }
}
