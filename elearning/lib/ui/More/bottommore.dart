import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';

class MyMorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Page'),
         backgroundColor: Theme.of(context).primaryColor,// Set app bar color to blue
        actions: <Widget>[
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Social Feed'),
            onTap: () {
              // Implement social feed functionality here
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Reports'),
            onTap: () {
              // Implement reports functionality here
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text('Downloads'),
            onTap: () {
              // Implement downloads functionality here
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Implement logout functionality here
            },
          ),
          // Add more ListTile for additional options
        ],
      ),
      
    );
  }
}
