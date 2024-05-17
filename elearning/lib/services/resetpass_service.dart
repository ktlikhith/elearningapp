import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordResetService {
  final String apiUrl;

  PasswordResetService(this.apiUrl);

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      var newUrl = apiUrl+"/webservice/rest/server.php";
     
      final response = await http.post(
        Uri.parse(newUrl),
        body: {
          'moodlewsrestformat': 'json',
          'wstoken': 'ea87559594d7a2a15a8bd474b9a17926',
          'wsfunction': 'core_auth_request_password_reset',
          'email': email,
        },
      );
      

      if (response.statusCode == 200) {
     
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server,$e');
    }
  }
}
