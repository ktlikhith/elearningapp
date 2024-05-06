import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  Future<bool> updateUserProfile({
    required String token,
    required int userId,
    required String username,
    required String schoolType,
    required String schoolName,
    required String dobType,
    required String dobValue,
    required String phone,
  }) async {
    try {
      // Prepare the request body
      var body = {
        'moodlewsrestformat': 'json',
        'wstoken': token,
        'wsfunction': 'core_user_update_users',
        'users[0][id]': userId.toString(),
        'users[0][username]': username,
        'users[0][customfields][0][type]': dobType,
        'users[0][customfields][0][value]': dobValue,
        'users[0][customfields][1][type]': schoolType,
        'users[0][customfields][1][value]': schoolName,
        'users[0][phone1]': phone,
      };

      // Make the POST request
      var response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        var data = json.decode(response.body);
        // Check if the update was successful
        if (data['status'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        // If the request was not successful, throw an exception
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      // If an error occurs during the request, throw an exception
      throw Exception('Failed to update user profile: $e');
    }
  }
}
