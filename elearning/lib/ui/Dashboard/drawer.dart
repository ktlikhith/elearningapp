import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/img1.jpeg'), // Profile photo goes here
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe', // Name goes here
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person), // Icon for "My Profile" list item
            title: Text('My Profile'),
            onTap: () {
               Navigator.of(context).pushNamed(RouterManger.myprofile);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer), // Icon for "Ask Experts" list item
            title: Text('Ask Experts'),
            onTap: () {
              Navigator.of(context).pushNamed(RouterManger.Askexpert);
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download), // Icon for "Downloads" list item
            title: Text('Downloads'),
            onTap: () {
             Navigator.of(context).pushNamed(RouterManger.downloads);
            },
          ),
          
          ListTile(
            leading: Icon(Icons.report), // Icon for "Report" list item
            title: Text('Report'),
            onTap: () {
              // Handle drawer item 1 tap
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app), // Icon for "Logout" list item
            title: Text('Logout'),
            onTap: () {
              // Handle drawer item 1 tap
            },
          ),
        ],
      ),
    );
  }
}
