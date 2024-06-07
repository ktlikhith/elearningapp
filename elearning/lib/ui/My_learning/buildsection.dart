// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shimmer/shimmer.dart';

// int toIntValue(dynamic value) {
//   if (value is int) {
//     return value;
//   } else if (value is double) {
//     return value.round(); // Round the double to the nearest integer
//   } else {
//     throw ArgumentError('Value must be either int or double');
//   }
// }
// Widget buildSection({
//   required String iconPath,
//   required  var number,
//   required String title,
//   bool isLoading = false,
// }) {
//   int intValue = toIntValue(number);
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: isLoading
//         ? _buildShimmerEffect()
//         : Container(
//             width: 130.0,
//             margin: const EdgeInsets.only(right: 16.0),
//             decoration: BoxDecoration(
//                boxShadow: [
//           BoxShadow(
//             color: Color.fromARGB(255, 232, 232, 232).withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 2,
//             offset: Offset(0, 4),
//           ),
//         ],
//               color: Color.fromARGB(255, 245, 244, 244),
//               borderRadius: BorderRadius.circular(12.0),
//               border: Border.all(
//                 color: const Color.fromARGB(255, 227, 236, 227),
//                 width: 2.0,
//               ),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleAvatar(
//                       child: Image.asset(iconPath),
//                     ),
//                     Text(
//                       '$intValue',
//                       style: const TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//   );
// }

// Widget _buildShimmerEffect() {
//   return Shimmer.fromColors(
//     baseColor: Colors.grey[300]!,
//     highlightColor: Colors.grey[100]!,
//     child: Container(
//       width: 130.0,
//       margin: const EdgeInsets.only(right: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: const Color.fromARGB(255, 227, 236, 227),
//           width: 2.0,
//         ),
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40.0,
//             height: 40.0,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 8.0),
//           Container(
//             width: 80.0,
//             height: 16.0,
//             color: Colors.grey,
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';

int toIntValue(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.round(); // Round the double to the nearest integer
  } else {
    throw ArgumentError('Value must be either int or double');
  }
}

Widget buildSection({
  required String iconPath,
  required var number,
  required String title,
  required context,

  bool isLoading = false,
}) {
  int intValue = toIntValue(number);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: isLoading
        ? _buildShimmerEffect()
        : Container(
            width: 180.0, // Adjusted width to match the design
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Theme.of(context ).secondaryHeaderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 232, 232, 232).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Circle background color
                  ),
                  child: Center(
                    child: Image.asset(
                      iconPath,
                      width: 35.0,
                      height: 35.0,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        '$intValue',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.0,fontWeight: FontWeight.bold,color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
  );
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: 150.0, // Adjusted width to match the design
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color.fromARGB(255, 227, 236, 227),
          width: 2.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            color: Colors.grey,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.0,
                height: 16.0,
                color: Colors.grey,
              ),
              SizedBox(height: 8.0),
              Container(
                width: 100.0,
                height: 16.0,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
