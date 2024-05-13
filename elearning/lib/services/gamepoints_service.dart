import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class RewardPointService {
  final String baseUrl = '${Constants.baseUrl}';

  Future<Map<String, dynamic>> addReward({
    required String token,
    required String type,
    required int points,
  }) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse(
          '$baseUrl/webservice/rest/server.php?'
          'wstoken=$token&'
          'wsfunction=local_reward_add_point&'
          'moodlewsrestformat=json&'
          'userid=$userId&'
          'type=$type&'
          'point=$points');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic>) {
         
          return decodedResponse;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to add reward. HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error adding reward: $e');
    }
  }
}
