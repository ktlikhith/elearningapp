import 'package:flutter/material.dart';


Widget buildProgressBar(String title, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            value: percentage / 100, 
          ),
          const SizedBox(height: 2),
          Text('$percentage%'),
          
        ],
      ),
    );
  }