import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Landingscreen/landingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Token exists, navigate directly to HomeScreen
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
    } else {
      // No token, navigate to LandingPage
      Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder widget, not used for UI
  }
}
