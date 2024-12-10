import 'package:elearning/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get profileData => _profileData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfileData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call your _fetchProfileData function
         SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }
      _profileData = await _fetchProfileData(token);
    } catch (e) {
      _errorMessage = 'Error fetching profile data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      final profilePictureMatch = RegExp(r'src="([^"]+)"')
          .firstMatch(data['user_info'][0]['studentimage']);
      final profilePictureUrl = profilePictureMatch?.group(1) ?? '';

      return {
        'studentName': data['user_info'][0]['studentname'],
        'studentEmail': data['user_info'][0]['studentemail'],
        'department': data['user_info'][0]['department'],
        'profilePictureUrl': profilePictureUrl,
        'userPoints': data['achievements'][0]['userpoints'],
        'badgesEarn': data['achievements'][0]['badgesearn'],
        'userLevel': data['achievements'][0]['userlevel'],
        'completioned': data['course_progress']['completioned'],
        'inProgress': data['course_progress']['inprogress'],
        'totalNotStarted': data['course_progress']['totalnotstarted'],
      };
    } catch (e) {
      print('Error fetching profile data: $e');
      throw e;
    }
  }
}
