import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void showNetworkError(BuildContext context) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Network issue: No Internet connection or the request timed out. Please check your connection and try again.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  });
}

