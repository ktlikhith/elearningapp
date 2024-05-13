import 'dart:convert';

import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class CourseContentApiService {
  
  Future<Map<String, dynamic>> fetchCourseContentData(String token, String courseId) async {
    final userInfo = await SiteConfigApiService.getUserId(token);
   
    final userId = userInfo['id'];
    try {
      final apiUrl = Uri.parse(
          '${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json&wstoken=$token&'
          'wsfunction=local_corporate_api_course_contentapi'
          '&userid=$userId&courseid=$courseId');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic>) {
          
          return decodedResponse; // Return the entire decoded response
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching course content data: $e');
    }
  }
}
