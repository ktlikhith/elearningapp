

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';



 Widget buildAchievement(String value, String label, String icon) {
    return Column(
      children: [
        Image.asset(icon,width: 30,),
        const SizedBox(height: 5),
        Text(value, style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
        //color: Color(0xFF1A43BF)
        color:Colors.white)),
        const SizedBox(height: 5),
        Text(label, style:  TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.blue[200])),
      ],
    );
  }