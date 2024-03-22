import 'dart:math';
import 'package:flutter/material.dart';
import 'gameappbar.dart';

class SpinWheel extends StatefulWidget {
  @override
  _SpinWheelState createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Adjust duration as needed
    );
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _spinWheel, // Call _spinWheel function on tap
      child: RotationTransition(
        turns: _animation,
        child: Container(
          width: 200, // Adjust size as needed
          height: 200, // Adjust size as needed
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 5), // Optional border
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    'assets/images/spin wheel image.png', // Replace with your actual spin wheel image path
                    fit: BoxFit.contain, // Fit the image inside without cropping
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
