import 'package:flutter/material.dart';

class GamificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Container(
              width: 200,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.lightBlueAccent, Colors.blue],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.card_giftcard, size: 50, color: Colors.white),
                  Image.asset('assets/images/login_Bacground.jpg', width: 50), // Adjust the width as needed
                  Text(
                    'My Points',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildHorizontalDiv(
                    backgroundColor: Colors.red,
                    topIcon: Icons.login,
                    label: 'Login Points',
                  ),
                  SizedBox(width: 6),
                  _buildHorizontalDiv(
                    backgroundColor: Colors.green,
                    topIcon: Icons.help_outline,
                    label: 'Daily Quiz Points',
                  ),
                  SizedBox(width: 6),
                  _buildHorizontalDiv(
                    backgroundColor: Colors.brown,
                    topIcon: Icons.casino,
                    label: 'Spin Wheel Points',
                  ),
                  SizedBox(width: 6),
                  _buildHorizontalDiv(
                    backgroundColor: Colors.blue,
                    topIcon: Icons.emoji_events,
                    label: 'Reward Received',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalDiv({
    required Color backgroundColor,
    required IconData topIcon,
    required String label,
  }) {
    return Container(
      width: 120, // Adjusted width to fit within the screen
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(topIcon, size: 30, color: Colors.white),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center, // Center the text horizontally
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GamificationPage(),
  ));
}


