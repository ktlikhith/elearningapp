// import 'package:flutter/material.dart';
// import 'package:elearning/services/reward_service.dart';

// class RewardProvider extends ChangeNotifier {
//   RewardData? rewardData;
//   bool isLoading = false;
//   String error = '';

//   Future<void> fetchRewardData(String token) async {
//     isLoading = true;
//     error = '';
//     notifyListeners();

//     try {
//       rewardData = await RewardService.getUserRewardPoints(token);
//     } catch (e) {
//       error = 'Failed to load reward data';
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Optional: If you want a refresh method
//   Future<void> refreshRewardData(String token) async {
//     await fetchRewardData(token);
//   }
// }
