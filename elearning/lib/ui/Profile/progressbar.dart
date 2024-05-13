import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



Widget buildProgressBar(String title, int percentage) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '$title:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 18,
          child: LinearPercentIndicator(
            barRadius: Radius.circular(30),
            lineHeight: 14.0,
            linearStrokeCap: LinearStrokeCap.roundAll,
            percent: percentage / 100,
            backgroundColor: Color.fromARGB(255, 204, 205, 205),
            progressColor: Colors.orange,
            center: Text(
              "$percentage%",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}
