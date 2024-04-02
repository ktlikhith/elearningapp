import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';

import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';

import 'package:flutter/material.dart';
import 'upcoming_event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DashboardPage();
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor, // Use primaryColor from theme
        elevation: 0, // Remove app bar shadow // Remove app bar shadow
        leading:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
          image: AssetImage('assets/images/img1.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () {
              // Handle notification icon press
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouterManger.myprofile);
              },
              
              child: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/img1.jpeg'),
        ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor, // Set background color to white
      body: SingleChildScrollView(
        controller: _scrollController, // Attach scroll controller
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
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
              const SizedBox(height: 25.0),
              AutoScrollableSections(),
              const SizedBox(height: 15.0),
              const UpcomingEventsSection(),
              const SizedBox(height: 15.0),
              CustomDashboardWidget(),
            ],
          ),
        ),
      ),
       bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0),
    );
  }
       
    
  }

