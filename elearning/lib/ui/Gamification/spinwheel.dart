import 'dart:math';
import 'package:flutter/material.dart';
import 'package:elearning/ui/Gamification/gameappbar.dart';

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
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'SPIN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
