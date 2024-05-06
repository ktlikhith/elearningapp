
import 'package:elearning/services/resetpass_service.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final PasswordResetService passwordResetService;

  const ForgotPasswordScreen({Key? key, required this.passwordResetService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
            },
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 10),
            Text(
              'Forgot Password?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Enter your email address or username below to receive password reset instructions.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: 'Email or Username',
                hintText: 'Enter your email or username',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email or username';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String input = inputController.text.trim();
                if (input.isNotEmpty) {
                  _resetPassword(context, input);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your email or username.'),
                    ),
                  );
                }
              },
              child: Text('Reset Password',style: TextStyle(color: Colors.white),),
              style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).secondaryHeaderColor, // Set button background color
                          ),
              
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context, String input) async {
    try {
      // Call the reset password service
      Map<String, dynamic> response =
          await passwordResetService.resetPassword(input, '');

      // Check the response and show appropriate message
      if (response.containsKey('status') &&
          response['status'] == 'dataerror') {
        // Handle error response
        String errorMessage = 'Failed to reset password';
        if (response.containsKey('warnings') &&
            response['warnings'] is List &&
            response['warnings'].isNotEmpty) {
          errorMessage = response['warnings'][0]['message'];
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      } else {
        // Password reset instructions sent successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset instructions sent to your email.'),
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
