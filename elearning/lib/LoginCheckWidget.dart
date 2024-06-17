// import 'package:flutter/material.dart';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/ui/Landingscreen/landingscreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginCheckWidget extends StatefulWidget {
//   @override
//   _LoginCheckWidgetState createState() => _LoginCheckWidgetState();
// }

// class _LoginCheckWidgetState extends State<LoginCheckWidget> {
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     setState(() {
//       _isLoggedIn = token != null && token.isNotEmpty;
//     });

//     if (_isLoggedIn) {
//       // Token exists, navigate directly to HomeScreen
//       Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
//     } else {
//       // No token, navigate to LandingPage
//       Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // Placeholder widget, not used for UI
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:elearning/routes/routes.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class LoginCheckWidget extends StatefulWidget {
//   @override
//   _LoginCheckWidgetState createState() => _LoginCheckWidgetState();
// }

// class _LoginCheckWidgetState extends State<LoginCheckWidget> {
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     setState(() {
//       _isLoggedIn = token != null && token.isNotEmpty;
//     });

//     if (_isLoggedIn) {
//       // Perform SSO login and store session data
//       await _performSSOLogin(token!);

//       // Navigate to HomeScreen
//       Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
//     } else {
//       // No token, navigate to LandingPage
//       Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
//     }
//   }
// Future<void> _performSSOLogin(String token) async {
//   final String url = 'https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=$token';

//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       // Assuming the session data is in the response body
//       String sessionData = response.body;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('session_data', sessionData);
//       print('SSO Login successful, session data stored.');
    
//     } else {
//       // Handle server errors
//       print('Failed to perform SSO login. Status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   } catch (e) {
//     // Handle network errors
//     print('Error performing SSO login: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Container(); // Placeholder widget, not used for UI
//   }
// }

import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
    });

    if (_isLoggedIn) {
      // Perform SSO login and store session data
      await _performSSOLogin(token!);

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
    } else {
      // No token, navigate to LandingPage
      Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
    }
  }

  Future<void> _performSSOLogin(String token) async {
    final String url = 'https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=$token';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Assuming the session data is in the response body
        String sessionData = response.body;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('ssotoken', token);
        await prefs.setString('session_data', sessionData);
        print('SSO Login successful, session data stored.');
      } else {
        // Handle server errors
        print('Failed to perform SSO login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle network errors
      print('Error performing SSO login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while checking login status
      ),
    );
  }
}
