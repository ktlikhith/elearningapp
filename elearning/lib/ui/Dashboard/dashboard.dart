import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/drawer.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'upcoming_event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      
       DashboardPage();
    
  }
}

class DashboardPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu button pressed
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.envelope),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ), 
      drawer: Builder(
        builder: (context) => DrawerContent(), // Use Builder to obtain context under Scaffold
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, John Doe!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Explore your courses and start learning.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 25.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSection("Past Due", "2", Colors.red),
                  buildSection("Due Soon", "5", Colors.yellow),
                  buildSection("Due Later", "10", Colors.grey),
                ],
              ),
              SizedBox(height: 15.0),

              Text(
                'Upcoming courses',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 15.0),

              UpcomingEventsSection(),
              
              SizedBox(height: 15.0),
              Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildContinueLearningSection(),
            ],
          ),
        ),
      ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0),
    );
  }

  Widget buildSection(String title, String number, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 10), // Adjust spacing between icon and number
          Container(
            padding: EdgeInsets.all(4.0),
            child: Text(
              number,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10), // Adjust spacing between number and title
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    ),
  );
}

}




