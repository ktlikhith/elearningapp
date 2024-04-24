
import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GamificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {
      'name': 'John Doe',
      'profilePictureUrl': 'https://example.com/profile1.jpg',
      'rank': 'Gold',
      'points': 500,
      'department': 'Sales',
    },
    {
      'name': 'Jane Smith',
      'profilePictureUrl': 'https://example.com/profile2.jpg',
      'rank': 'Silver',
      'points': 400,
      'department': 'Marketing',
    },
    // Add more entries as needed
  ];

  Widget buildPointsCategory(String title, IconData icon) {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.orange),
        columns: [
          DataColumn(
            label: Container(
              child: Text('#No', style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
          ),
          DataColumn(
            label: Container(
              child: Row(
                children: [
                  
                  SizedBox(width: 10),
                  Text('Name', style: TextStyle(color: Colors.white)),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
          ),
          DataColumn(
            label: Container(
              child: Text('Rank', style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
          ),
          DataColumn(
            label: Container(
              child: Text('Points', style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
          ),
          DataColumn(
            label: Container(
              child: Text('Department', style: TextStyle(color: Colors.white)),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            ),
          ),
        ],
        rows: List<DataRow>.generate(
          leaderboardData.length,
          (index) => DataRow(cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(leaderboardData[index]['profilePictureUrl']),
                  ),
                  SizedBox(width: 10),
                  Text(leaderboardData[index]['name']),
                ],
              ),
            ),
            DataCell(Text(leaderboardData[index]['rank'])),
            DataCell(Text(leaderboardData[index]['points'].toString())),
            DataCell(Text(leaderboardData[index]['department'])),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                'My Points',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Text(
              '1000', // Replace with actual points value
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40, width: 50),

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
      // bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3),
    );
  }
}

void main() {
  runApp(MaterialApp(home: GamificationPage()));
}