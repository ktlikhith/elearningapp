import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';



 Widget buildAchievement(String value, String label, IconData icon) {
    return Column(
      children: [
        FaIcon(icon, size: 30),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.orange)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
      ],
    );
  }