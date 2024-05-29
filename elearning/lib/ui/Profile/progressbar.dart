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

Widget buildProgressBar(String title, value, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final lineHeight = screenWidth < 600 ? 10.0 : 14.0;
  final fontSize = screenWidth < 600 ? 10.0 : 12.0;

  int intValue = toIntValue(value);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontSize: screenWidth < 600 ? 14 : 16, // Adjust title font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8), // Add some space between the title and progress bar
        LinearPercentIndicator(
          barRadius: Radius.circular(30),
          lineHeight: lineHeight,
          linearStrokeCap: LinearStrokeCap.roundAll,
          percent: intValue / 100,
          backgroundColor: Color.fromARGB(255, 204, 205, 205),
          progressColor: Colors.orange,
          center: Text(
            "$intValue%",
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
