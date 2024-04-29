import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;


class Rewardservice{
  Future<Map<String, dynamic>> getUserRewardPoints(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final username = userInfo['username'];

      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?wstoken=$token&wsfunction=local_reward_points_user&moodlewsrestformat=json&username=$username',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final rewardData = jsonResponse['reward_data'];
       
        return rewardData;
      } else {
        throw Exception('Failed to load user reward points');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user reward points');
    }
  }
  
}
