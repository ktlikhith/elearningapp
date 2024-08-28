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
  required BuildContext context,
  required Color1,
  bool isLoading = false,
}) {
  int intValue = toIntValue(number);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: isLoading
        ? _buildShimmerEffect()
        : Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Container(
                width: 200,
                height: 80,
                padding: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  
                  borderRadius: BorderRadius.circular(9.0),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  color: Theme.of(context).hintColor.withOpacity(.1),
                 boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$intValue',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        title,
                        style:  TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Positioned(
                right: -10,
                top: -30,
                bottom: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(.2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        bottomRight: Radius.circular(45.0),
                        bottomLeft: Radius.circular(45.0),
                      ),
                    ),
                     child: Stack(
                children: [
                  Positioned(
                    right: 18,
                    top: 23,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                     Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        child: Center(
                          child: Image.asset(iconPath, width: 30, height: 30),
                        ),
                      ),
                    ),
                ]
                     ),
                  ),
                ),
              ),
                Container(
          width: 200,
          height: 80,
          padding: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(
              color: Theme.of(context).cardColor,
            ),
           
          ),
          ),
            ],
            
          ),
  );
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color.fromARGB(255, 227, 236, 227),
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}
