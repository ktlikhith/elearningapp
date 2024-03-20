import 'package:flutter/material.dart';


Widget buildProgressBar(String title, int percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            '$title: ',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            value: percentage / 100, 
          ),
          SizedBox(height: 2),
          Text('$percentage%'),
          
        ],
      ),
    );
  }