import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

int toIntValue(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.round(); // Round the double to the nearest integer
  } else {
    throw ArgumentError('Value must be either int or double');
  }
}

Widget buildProgressBar(String title, value) {
  int intValue = toIntValue(value);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8), // Add some space between the title and progress bar
        LinearPercentIndicator(
          barRadius: Radius.circular(30),
          lineHeight: 16.5,
          linearStrokeCap: LinearStrokeCap.roundAll,
          percent: value/100 ,
          backgroundColor: Color.fromARGB(255, 204, 205, 205),
          progressColor: Colors.orange,
          center: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              "$value%",
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}
