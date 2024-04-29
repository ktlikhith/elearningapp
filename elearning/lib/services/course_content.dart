import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class CourseContentApiService {
  Future<Map<String, dynamic>> fetchCourseContentData(String token,String courseId) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
       

        final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
            'moodlewsrestformat=json&wstoken=$token&'
            'wsfunction=local_corporate_api_course_contentapi'
            '&userid=$userId&courseid=$courseId');
        final response = await http.get(apiUrl);

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } 
       else {
        throw Exception('No courses found for the user');
      }
    } catch (e) {
      throw Exception('Error fetching course content data: $e');
    }
  }
}
