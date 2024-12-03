import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageProvider with ChangeNotifier {
  List<CourseData> _allCourses = [];
  bool _isLoading = false;
  String? _error;

  List<CourseData> get allCourses => _allCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllCourses() async {
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
      _allCourses = homePageData.allCourses;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
