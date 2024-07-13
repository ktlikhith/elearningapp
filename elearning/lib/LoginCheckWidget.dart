
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LoginCheckWidget extends StatefulWidget {
  @override
  _LoginCheckWidgetState createState() => _LoginCheckWidgetState();
}

class _LoginCheckWidgetState extends State<LoginCheckWidget> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3)); // Add delay to show splash screen

    String updateRequired = await _checkForUpdate();
    if (updateRequired != "false") {
      // Show update dialog
      _showUpdateDialog(updateRequired);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
    });

    if (_isLoggedIn) {
      // Perform SSO login and store session data

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
    } else {
      // No token, navigate to LandingPage
      Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
    }
  }

  Future<String> _checkForUpdate() async {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String currentVersion = packageInfo.version;
    String latestVersion = "1.0.0";
    String update_android_link="hi";
    String update_ios_link="hello";

    if (currentVersion.compareTo(latestVersion) < 0) {
      if(Platform.isAndroid){
        return update_android_link;
      }
        else {
          return update_ios_link;
        }

      
        
      }else{
        return('false');
      }

    // final response = await http.get(Uri.parse('https://yourapi.com/update-status'));

    // if (response.statusCode == 200) {
    //   var data = json.decode(response.body);
    //   String latestVersion = data['latest_version'];
    //   String updateLink = data['update_link'];
    //   if (currentVersion.compareTo(latestVersion) < 0) {
    //     return updateLink;
    //   }
    // } else {
    //   // Handle error
    //   print('Failed to fetch update status');
    // }
    // return "false";
  }

  void _showUpdateDialog(String updateLink) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Text('A new version of the app is available. Please update to continue.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                // Close the app
                 SystemNavigator.pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              

                  onPressed: () async {
                // Open the app store or play store link based on the platform
              
               
                if (await canLaunch(updateLink)) {
                  await launch(updateLink);
                } else {
                  print('Could not launch $updateLink');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('assets/images/eapplogo.png', width: MediaQuery.of(context).size.height * 0.1),
      ),
    );
  }
}
