import 'package:flutter/material.dart';
import 'package:elearning/services/resetpass_service.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final PasswordResetService passwordResetService;

  const ForgotPasswordScreen({Key? key, required this.passwordResetService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Forgot Your Password?',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              'assets/images/svg/key-svgrepo-com.svg',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Don't worry! It happens sometimes. Please enter the email associated with your account, we'll send you a code to reset your password.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Enter Your Registered Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.email, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!isValidEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _resetPassword(context, _emailController.text);
                }
              },
              child: Text('Send Code', style: TextStyle(color: Colors.white, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20), // Add some space at the bottom
        ],
      ),
    );
  }

  void _resetPassword(BuildContext context, String email) async {
    try {
      // Call the reset password service
      Map<String, dynamic> response =
          await passwordResetService.resetPassword(email);

      // Check the response and show appropriate message
      if (response.containsKey('status') &&
          response['status'] == 'emailpasswordconfirmmaybesent') {
        // Password reset instructions sent successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Remove HTML tags from the notice message
            String notice = _removeHtmlTags(response['notice']);
            return AlertDialog(
              title: Text('Password Reset Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(notice),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.containsKey('status') &&
          response['status'] == 'emailnotfound') {
        // Email not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email not found. Please enter a valid email.'),
          ),
        );
      } else {
        // Handle other status or errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset password. Please try again.'),
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

  String _removeHtmlTags(String htmlString) {
    // Use regular expression to remove HTML tags
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  bool isValidEmail(String email) {
    // Simple email validation regex
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);
  }
}
