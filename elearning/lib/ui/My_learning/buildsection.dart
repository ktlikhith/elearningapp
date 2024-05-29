import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isLoading = false,
}) {
  int intValue = toIntValue(number);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: isLoading
        ? _buildShimmerEffect()
        : Container(
            width: 130.0,
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
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
                      child: Image.asset(iconPath),
                    ),
                    Text(
                      '$intValue',
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
                      fontSize: 14.0,
                    ),
                  ),
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
      width: 130.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
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
          Container(
            width: 40.0,
            height: 40.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 8.0),
          Container(
            width: 80.0,
            height: 16.0,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
