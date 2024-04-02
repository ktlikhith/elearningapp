import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Widget buildAchievement(String number, String title, IconData iconData) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300], // Grey background color
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          number,
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
}
