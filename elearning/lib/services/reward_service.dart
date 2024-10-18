import 'dart:async';
import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class RewardService {
  
  Stream<RewardData> getUserRewardPoints(String token) async* {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final username = userInfo['username'];

      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?wstoken=$token&wsfunction=local_reward_points_user&moodlewsrestformat=json&username=$username',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final rewardData = RewardData.fromJson(jsonResponse['reward_data']);
     
        yield rewardData;
      } else {
        throw Exception('Failed to load user reward points');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user reward points');
    }

  }
  
    Stream<spinwheel> getspinwheel(String token) {
    return Stream.periodic(Duration(seconds: 1), (_) async {
      // Fetch leaderboard data
   final userInfo = await SiteConfigApiService.getUserId(token);
      final username = userInfo['username'];

      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?wstoken=$token&wsfunction=local_reward_points_user&moodlewsrestformat=json&username=$username',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final rewardData = spinwheel.fromJson(jsonResponse['reward_data']);
     
        return rewardData;
      } else {
        throw Exception('Failed to fetch leaderboard');
      }
    }).asyncMap((future) => future); // Convert Future to Stream
  }

  //   final _rewardStreamController = StreamController<RewardData>.broadcast();

  //    Stream<RewardData> streamreward(String token) {
     
  //       // final stream_data =_rewardStreamController.stream.asBroadcastStream();
  //   return Stream.periodic(Duration(seconds: 1), (_) async {
  //     // Fetch reward data
  //    final userInfo = await SiteConfigApiService.getUserId(token);
  //     final username = userInfo['username'];

  //     final apiUrl = Uri.parse(
  //       '${Constants.baseUrl}/webservice/rest/server.php?wstoken=$token&wsfunction=local_reward_points_user&moodlewsrestformat=json&username=$username',
  //     );

  //     final response = await http.get(apiUrl);

  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       final rewardData = RewardData.fromJson(jsonResponse['reward_data']);
  //   _rewardStreamController.sink.add(rewardData);
    
  //       return rewardData;
  //     } else {
  //       throw Exception('Failed to fetch leaderboard');
  //     }
  //   }).asyncMap((future) => future); // Convert Future to Stream
  // }
}
class spinwheel{
  final bool spinButton;
  spinwheel({
required this.spinButton,
  });
   factory spinwheel.fromJson(Map<String, dynamic> json) {
    return spinwheel(
      spinButton: json['spinbutton'] == true || json['spinbutton'] == 'true',
    );
   }
}

class RewardData {
  final String fullname;
  final String email;
  final String department;
  final String designation;
  final String empcode;
  final String phone;
  final String profileImage;
  final  myRank;
  final String availablePoints;
  final String totalPoints;
  final  redeemPoints;
  final  averageGrade;
  final bool spinButton;
  final  pointsNeeded;
  final  gradeNeeded;
  final String nextLevel;
  final  loginPoints;
  final  quizPoints;
  final  spinwheelPoints;
  final  rewardsReceivedPoints;

  RewardData({
    required this.fullname,
    required this.email,
    required this.department,
    required this.designation,
    required this.empcode,
    required this.phone,
    required this.profileImage,
    required this.myRank,
    required this.availablePoints,
    required this.totalPoints,
    required this.redeemPoints,
    required this.averageGrade,
    required this.spinButton,
    required this.pointsNeeded,
    required this.gradeNeeded,
    required this.nextLevel,
    required this.loginPoints,
    required this.quizPoints,
    required this.spinwheelPoints,
    required this.rewardsReceivedPoints,
  });

  factory RewardData.fromJson(Map<String, dynamic> json) {
    return RewardData(
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      empcode: json['empcode'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileimage'] ?? '',
      myRank: json['my_rank'] ?? '',
      availablePoints: json['available_points'] ?? '',
      totalPoints: json['total_points'] ?? '',
      redeemPoints: json['redeem_points'] ?? 0,
      averageGrade: json['average_grade'] ?? 0,
       spinButton: json['spinbutton'] == true || json['spinbutton'] == 'true',
      pointsNeeded: json['points_needed'] ?? 0,
      gradeNeeded: json['grade_needed'] ?? '',
      nextLevel: json['nextlevel'] ?? '',
      loginPoints: int.parse(json['login_points'].toString()),
      quizPoints: int.parse(json['quiz_points'].toString()),
      spinwheelPoints: int.parse(json['spinwheel_points'].toString()),
      rewardsReceivedPoints: int.parse(json['rewards_received_points'].toString()),
    );
  }


}





