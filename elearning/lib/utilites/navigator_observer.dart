import 'package:flutter/material.dart';

class NavigatorObserver_ extends NavigatorObserver {
  final Function onPopCallback;

  NavigatorObserver_({required this.onPopCallback});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Call the callback when a screen is popped
    onPopCallback();
  }
}
