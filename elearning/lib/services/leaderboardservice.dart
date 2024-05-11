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
        'wstoken=$token&'
        'wsfunction=local_reward_get_leaderboard&moodlewsrestformat=json&userid=$userId',

       
      );
      final response = await http.get(apiUrl);

       if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> usersData = responseData as List<dynamic>;
        print(usersData);
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
  final String image;
  final String name;
  final String department;
  final String rank;
  final String points;
  final String rank_icon;

  User({
    required this.image,
    required this.name,
    required this.department,
    required this.rank,
    required this.points,
    required this.rank_icon,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      image: json['image'],
      name: json['name'],
      department: json['department'],
      rank: json['user_rank'],
      points: json['available_points'],
      rank_icon: json['rank_icon'],
    );
  }
}



