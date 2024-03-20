import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'ui/Dashboard/dashboard.dart';


void main() {
  runApp(ElearningApp());
}

class ElearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
    );
  }

   


}


