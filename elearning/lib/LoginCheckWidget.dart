
import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
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
      // Perform SSO login and store session data

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
    } else {
      // No token, navigate to LandingPage
      Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
    }
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
        child: Image.asset('assets/images/eapplogo.png'), // Replace with your splash screen image
      ),
    );
  }
}
