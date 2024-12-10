import 'package:elearning/services/reward_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardProvider extends ChangeNotifier {
  final RewardService _rewardService = RewardService();

  RewardData? _rewardData;
  spinwheel? _spinWheelData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  RewardData? get rewardData => _rewardData;
  spinwheel? get spinWheelData => _spinWheelData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch reward points
  Future<void> fetchRewardPoints() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }
      await for (var data in _rewardService.getUserRewardPoints(token)) {
        _rewardData = data;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fetch spin wheel data
  Future<void> fetchSpinWheelData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
           SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }
      await for (var data in _rewardService.getspinwheel(token)) {
        _spinWheelData = data;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
