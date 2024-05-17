import 'dart:convert';

import 'package:elearning/routes/routes.dart';

import 'package:elearning/services/profile_service.dart';
import 'package:elearning/ui/Learning_path/learningpath.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMorePage extends StatefulWidget {
  final String token;

  const MyMorePage({Key? key, required this.token}) : super(key: key);

  @override
  _MyMorePageState createState() => _MyMorePageState();
}

 
class _MyMorePageState extends State<MyMorePage> {
   late String _profilePictureUrl = '';

   @override
  void initState() {
    super.initState();
    _fetchProfileData(widget.token);
  }
  Future<void> _clearToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  // Navigate back to the landing page or login screen if needed
}

  Future<void> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      setState(() {
        final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
        if (profilePictureMatch != null) {
          _profilePictureUrl = profilePictureMatch.group(1)!;
        }
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('More Page'),
           centerTitle: false,
           leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.homescreen,arguments: widget.token);
          },
        ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
                },
                child: CircleAvatar(
                  radius: 20,
                 backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
       body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(RouterManger.learningpath, arguments: widget.token);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.graduationCap),
              title: Text('Learning Path'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(RouterManger.Report, arguments: widget.token);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.chartSimple),
              title: Text('Reports'),
            ),
          ),
          InkWell(
            onTap: () {
              // Implement downloads functionality here
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.download),
              title: Text('Downloads'),
            ),
          ),
          InkWell(
            onTap: () {
              _clearToken();
              Navigator.of(context).pushReplacementNamed(RouterManger.landingpage);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: ListTile(
              leading: FaIcon(FontAwesomeIcons.rightFromBracket),
              title: Text('Logout'),
            ),
          ),
          
        ],
      ),

      ),
    );
  }


  
}
