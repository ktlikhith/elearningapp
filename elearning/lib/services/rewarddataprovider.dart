// import 'package:flutter/material.dart';
// import 'package:elearning/services/reward_service.dart'; // Assuming the path to RewardService

// class RewardNotifier extends ChangeNotifier {
//   RewardData? _rewardData;
//   bool _isLoading = false;
//   String _errorMessage = '';

//   RewardData? get rewardData => _rewardData;
//   bool get isLoading => _isLoading;
//   String get errorMessage => _errorMessage;

//   final RewardService _rewardService = RewardService();

//   // Fetch reward points for the user
//   Future<void> fetchUserRewardPoints(String token) async {
//     _isLoading = true;
//     _errorMessage = '';
//     notifyListeners();

//     try {
//       RewardData data = await _rewardService.getUserRewardPoints(token);
//       _rewardData = data;
//       _isLoading = false;
//     } catch (e) {
//       _isLoading = false;
//       _errorMessage = e.toString();
//     }

//     notifyListeners(); // Notify listeners after data is fetched
//   }

//   // Reset error message if needed
//   void resetError() {
//     _errorMessage = '';
//     notifyListeners();
//   }
// }
