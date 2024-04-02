import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  '1000', // Replace with actual points value
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
      ),
      backgroundColor: Theme.of(context).backgroundColor, 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildPointsCategory('Login Points', Icons.login, Color.fromARGB(205, 6, 10, 241)),
                          buildPointsCategory('Daily Quiz Points', Icons.quiz, Color.fromARGB(255, 25, 210, 31)),
                          buildPointsCategory('Spin Wheel Points', Icons.casino, Color.fromARGB(255, 227, 195, 13)),
                          buildPointsCategory('Reward Received', Icons.card_giftcard, const Color.fromARGB(255, 188, 9, 219)),
                        ],
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
                                 SpinWheel(),
                                Text('Spin the wheel and luck your chance to get points benefit and redeem.'),
                                ElevatedButton(
                                  onPressed: (){
                                    
                                    // Implement spin wheel functionality
                                  },
                                  child: Text('Spin'),
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
          ),
        ],
      ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3),
    );
  }

  Widget buildPointsCategory(String title, IconData icon, Color bgColor) {
    return Container(
      height: 120, // Set a fixed height for consistency
      width: 120, // Set a fixed width for consistency
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Color.fromARGB(255, 241, 236, 236)),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: const Color.fromARGB(255, 8, 0, 0), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            '500', // Replace with actual point value
            style: TextStyle(color: const Color.fromARGB(255, 13, 0, 0), fontSize: 14),
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

