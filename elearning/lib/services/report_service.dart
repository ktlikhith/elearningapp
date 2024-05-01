import 'dart:convert';
// import 'dart:html';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ReportApiService {
  // final String baseUrl =
  //     "https://lxp-demo2.raptechsolutions.com/webservice/rest/server.php";

  Future<Map<String, dynamic>> fetchUserActivity(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final url = '${Constants.baseUrl}?moodlewsrestformat=json&wstoken=$token&wsfunction=local_corporate_api_user_reportapi&userid=$userId';

      final response = await http.get(Uri.parse(url));
      print('$response');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('error')) {
          throw Exception(responseData['error']);
        }
        return responseData;
      } else {
        throw Exception('Failed to load user activity');
      }
    } catch (e) {
      throw Exception('Error fetching user activity: $e');
    }
  }
}
