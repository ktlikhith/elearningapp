import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Widget buildAchievement(String value, String label, IconData icon, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final iconSize = screenWidth < 600 ? 20.0 : 27.0;
  final fontSize = screenWidth < 600 ? 12.0 : 16.0;

  return Column(
    children: [
      FaIcon(icon, size: iconSize),
      SizedBox(height: 5),
      Text(value, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.orange)),
      SizedBox(height: 5),
      Text(label, style: TextStyle(fontSize: fontSize + 2, fontWeight: FontWeight.bold)),
    ],
  );
}
