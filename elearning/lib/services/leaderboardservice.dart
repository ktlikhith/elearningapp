import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class LeaderboardService {
  static Future<List<User>> fetchLeaderboard(String token) async {
    try {
     final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_reward_get_leaderboard&userid=$userId',
      );
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> usersData = responseData['users'];
        return usersData.map((userData) => User.fromJson(userData)).toList();
      } else {
        throw Exception('Failed to fetch leaderboard');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard: $e');
    }
  }
}

class User {
  final String profileUrl;
  final String name;
  final String department;
  final int rank;
  final int points;

  User({
    required this.profileUrl,
    required this.name,
    required this.department,
    required this.rank,
    required this.points,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profileUrl: json['profile_url'],
      name: json['name'],
      department: json['department'],
      rank: json['rank'],
      points: json['points'],
    );
  }
}
