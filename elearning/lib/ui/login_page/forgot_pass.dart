import 'package:flutter/material.dart';
import 'package:elearning/services/resetpass_service.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final PasswordResetService passwordResetService;

  const ForgotPasswordScreen({Key? key, required this.passwordResetService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHorizontal = screenWidth * 0.08;
    final double paddingVertical = screenHeight * 0.05;
    final double iconSize = screenWidth * 0.08;
    final double fontSizeLarge = screenHeight * 0.03;
    final double fontSizeMedium = screenHeight * 0.025;
    final double fontSizeSmall = screenHeight * 0.02;

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
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Your Password ?',
                          style: TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: iconSize,
                          height: iconSize,
                          child: SvgPicture.asset(
                            'assets/images/svg/key-svgrepo-com.svg',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Don't worry! It happens sometimes. Please enter the email associated with your account, we'll send you a code to reset your password",
                      style: TextStyle(fontSize: fontSizeMedium),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Enter Your Registered Email',
                      style: TextStyle(
                        fontSize: fontSizeMedium,
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword(context, _emailController.text);
                  }
                },
                child: Text('Send Code', style: TextStyle(color: Colors.white, fontSize: fontSizeMedium)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword(BuildContext context, String email) async {
    try {
      // Call the reset password service
      Map<String, dynamic> response = await passwordResetService.resetPassword(email);

      // Check the response and show appropriate message
      if (response.containsKey('status') && response['status'] == 'emailpasswordconfirmmaybesent') {
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
      } else if (response.containsKey('status') && response['status'] == 'emailnotfound') {
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
