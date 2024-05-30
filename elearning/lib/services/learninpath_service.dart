import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class LearningPathApiService {
  static Future<Map<String, dynamic>> fetchLearningPathData(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json&wstoken=$token&'
          '&wsfunction=local_corporate_api_create_learningpathapi'
          '&userid=$userId');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch learning path data');
      }
    } catch (e) {
      throw Exception('Error fetching learning path data: $e');
    }
  }
}

