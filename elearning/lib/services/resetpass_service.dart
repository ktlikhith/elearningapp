import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordResetService {
  final String apiUrl;

  PasswordResetService(this.apiUrl);

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'moodlewsrestformat': 'json',
          'wstoken': 'your_token_here',
          'wsfunction': 'core_auth_email_password_reset',
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
