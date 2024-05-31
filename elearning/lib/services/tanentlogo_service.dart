import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/profile_service.dart';
import 'package:http/http.dart' as http;


class TanentLogo {
  static Future<Map<String, dynamic>> fetchTenantUserData(String token) async {
    try {
       final userInfo = await SiteConfigApiService.getUserId(token);
      final username = userInfo['username'];
      final data = await ProfileAPI.fetchProfileData(token);
     
        final response = await http.get(Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?moodlewsrestformat=json&wstoken=$token&wsfunction=tenent_users_data&tenant[0][username]=$username'));

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } 
       else {
        throw Exception('No user information found');
      }
    } catch (e) {
      throw Exception('Error fetching tenant user data: $e');
    }
  }
  // Add other service methods as needed
}