import 'package:flutter/material.dart';


Widget buildSection({required IconData icon, required int number, required String title}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 130.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
            boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
            color: Color.fromARGB(255, 234, 232, 232),
            borderRadius: BorderRadius.circular(12.0),
           border: Border.all(
            color: Color(0xFFFFA000), // Green border color
            width: 2.0,
          ),
        //      gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //   Color(0xFFFFA000),    Color(0xFFD500F9), // Replace with your desired gradient colors
        //    // Example colors used here
        //   ],
        // ),
        
        
      ),
      padding: const EdgeInsets.all(16.0),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 216, 226, 234),
    
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
    ),
  );
}