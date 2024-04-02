import 'package:flutter/material.dart';


Widget buildSection({required IconData icon, required int number, required String title}) {
  return Container(
    width: 150.0,
    margin: const EdgeInsets.only(right: 16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      color: Colors.white,
      
    ),
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,

            child: Icon(icon, size: 20.0),
            ),
            Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
          ],
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
