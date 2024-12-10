  import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class activityprovider with ChangeNotifier {
 List<int> _activity=[];
 bool _isLoading = false;
  String? _error;
  
 List<int> get activity => _activity;
 bool get isLoading => _isLoading;
  String? get error => _error;
    Future<void> fetchpastsoonlater() async{
     _isLoading = true;
    _error = null;
    notifyListeners();

    try {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }

      HomePageData homePageData = await HomePageService.fetchHomePageData(token);
      _activity.add(homePageData.countActivity);
      _activity.add(homePageData.countSevenDays);
      _activity.add(homePageData.countThirtyDays);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }
    
  }
  
