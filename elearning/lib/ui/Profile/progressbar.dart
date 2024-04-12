

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


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
           LinearPercentIndicator(
                lineHeight: 30.0,
                linearStrokeCap: LinearStrokeCap.roundAll,
                percent: percentage / 100,
                backgroundColor: Colors.grey.shade300,
                progressColor: const Color.fromARGB(243, 255, 86, 34),
                center: Text("$percentage%"),
              ),
          
        ],
      ),
    );
  }