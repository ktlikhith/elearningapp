
import 'dart:async';

class LoginBloc {
  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();
  final _loginStatusController = StreamController<bool>();
  final _errorMessageController = StreamController<String>();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<bool> get loginStatusStream => _loginStatusController.stream;
  Stream<String> get errorMessageStream => _errorMessageController.stream;

  String testEmail = 'test@example.com'; // Test email
  String testPassword = 'password'; // Test password

  Function(String) get updateEmail => _emailController.sink.add;
  Function(String) get updatePassword => _passwordController.sink.add;

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _loginStatusController.close();
    _errorMessageController.close();
  }

  void authenticateUser(String email, String password) {
    if (email == testEmail && password == testPassword) {
      _loginStatusController.sink.add(true); // Login success
      _errorMessageController.sink.add(''); // Clear error message if any
    } else {
      _loginStatusController.sink.add(false); // Login failure
      _errorMessageController.sink.add('Invalid credentials'); // Set error message
    }
  }

  void login() {
    // String email = _emailController.stream.value ?? '';
    // String password = _passwordController.stream.value ?? '';
    // authenticateUser(email, password);
  }
}

final loginBloc = LoginBloc();





