import 'dart:async';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  List<EventData> _eventData = [];
  bool _isLoading = true;
  String? _error;
  Timer? _timer; // Timer for auto-fetching

  List<EventData> get eventData => _eventData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch events manually or during initial load
  Future<void> fetchEvent({bool isHomeRefresh = false}) async {
    _isLoading = isHomeRefresh ? true : false;
    _error = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }

      HomePageData homePageData = await HomePageService.fetchHomePageData(token);

      
      if (_eventData.isEmpty || _eventData != homePageData.evenData) {
        _eventData = homePageData.evenData;
        
        notifyListeners(); // Notify only if data changes
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  void startAutoFetch() {
    
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      fetchEvent(); // Fetch data in the background
    });
  }

 
  void stopAutoFetch() {
    _timer?.cancel();
  }

 
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
