import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


Widget buildSection({required String svgPath, required int number, required String title}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 130.0,
      margin: const EdgeInsets.only(right: 16.0),
       decoration: BoxDecoration(
         // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.3),
          //     spreadRadius: 2,
          //     blurRadius: 4,
          //     offset: Offset(0, 4),
          //   ),
          // ],
           color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color.fromARGB(255, 227, 236, 227),
            width: 2.0,
          ),
        ),
      padding: const EdgeInsets.all(16.0),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                // backgroundColor: Colors.orange,
    
              child: SvgPicture.asset(svgPath),
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