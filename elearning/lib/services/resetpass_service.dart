import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordResetService {
  final String baseUrl;

  PasswordResetService(this.baseUrl);

  Future<Map<String, dynamic>> resetPassword(String username, String email) async {
    try {
      var url = Uri.parse('$baseUrl/webservice/rest/server.php');
      var response = await http.post(
        url,
        body: jsonEncode({
          "username": username,
          "email": email,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
