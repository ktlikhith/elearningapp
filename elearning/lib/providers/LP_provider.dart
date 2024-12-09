import 'package:elearning/services/learninpath_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningPathProvider with ChangeNotifier {
  List<LearningPathDetail> _learningPaths = [];
  List<dynamic> _progressList = [];
  bool _isLoading = true;
  String? _error;

  List<LearningPathDetail> get learningPaths => _learningPaths;
  List<dynamic> get progressList => _progressList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLearningPaths() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('disposed');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }
      final data = await LearningPathApiService.fetchLearningPathData(token);
      _learningPaths = (data['learningpathdetail'] as List)
        .map((item) => LearningPathDetail.fromJson(item, data['learningpath_progress']))
        .toList();
      _progressList = data['learningpath_progress'];
    } catch (e) {
      _error = 'Failed to load data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
