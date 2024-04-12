

import 'package:elearning/services/auth.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final result = await AuthService.login(username, password, 'moodle_mobile_app');
      return result;
     
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
