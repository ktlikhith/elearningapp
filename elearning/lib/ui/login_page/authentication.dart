import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> authenticateUser(String email, String password) async {
  final apiUrl =
      'https://lxp-demo2.raptechsolutions.com/login/token.php?username=$email&password=$password&service=moodle_mobile_app';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // return jsonResponse.toString();
      if (jsonResponse['token'] != null) {
        return 'Successfully logged in';
      } else {
        return 'Invalid email or password combination';
      }
    }
     else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Error: $e';
  }
}
