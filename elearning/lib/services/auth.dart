import 'dart:convert';
import 'package:http/http.dart' as http;


class Constants {
  static const String baseUrl = 'https://lxp-demo2.raptechsolutions.com';
}


class AuthService {

  static Future<Map<String, dynamic>> login(String username, String password, String service) async {
    final url = Uri.parse('${Constants.baseUrl}/login/token.php?username=$username&password=$password&service=$service');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'token': responseData['token'],
        //'privateToken': responseData['privatetoken'],
      };
      
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}

class SiteConfigApiService {
  static Future<Map<String, dynamic>> getUserId(String token) async {
    final url = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json&wstoken=$token&serviceshortnames[0]=moodle_mobile_app');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> functions = responseData['functions'];
      final List<String> functionNames = functions.map((function) => function['name'].toString()).toList();
      
      return {
        'id': responseData['userid'],
        'fullname': responseData['fullname'],
        'firstname': responseData['firstname'],
        'userpictureurl': responseData['userpictureurl'],
        'siteurl': responseData['siteurl'],
        'functions': functionNames,
      };
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }
}


class DueApiService {
  static Future<Map<String, dynamic>> getDueInfo(String token, int userId, List<String> functionNames) async {
    try {
      final dueUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json&wstoken=$token&'
          'wsfunction=local_corporate_api_get_coursesapi&userid=$userId');
  
      final response = await http.get(dueUrl);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return{
          'pastcountactivity': responseData['pastcountactivity'],
          'countsevendays': responseData['countsevendays'],
          'countthirtydays': responseData['countthirtydays'],
          'functions': functionNames,
        };
      } else {
        throw Exception('Failed to fetch due information');
      }
    } catch (e) {
      print('Error fetching due information: $e');
      rethrow;
    }
  }
}
