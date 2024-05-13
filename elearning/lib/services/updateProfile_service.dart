import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileService {
  final String baseUrl;

  ProfileService(this.baseUrl);

  Future<bool> updateUserProfile({
    required String token,
    required int userId,
    required String username,
    required String firstname,
    required String lastname,
   // required String gmail,
    // required String schoolType,
    // required String schoolName,
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
        'users[0][firstname]': firstname,
        
        'users[0][lastname]': lastname,
        //'users[0][gmail]': gmail,
        // 'users[0][customfields][1][type]': schoolType,
        // 'users[0][customfields][1][value]': schoolName,
        'users[0][phone1]': phone,
        
      };
       //print('Request Body: $body');

      // Make the POST request
      var response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        var data = json.decode(response.body);
       // print(data);
        // Check if the update was successful
        return true;
      } else {
        // If the request was not successful, throw an exception with the HTTP status code
        throw Exception('Failed to update user profile. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an exception with the error message
      throw Exception('Failed to update user profile: $e');
    }
  }
}
