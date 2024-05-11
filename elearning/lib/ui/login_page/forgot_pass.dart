import 'package:flutter/material.dart';
import 'package:elearning/services/resetpass_service.dart';
import 'package:elearning/ui/login_page/login_screen.dart';

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
        title: Text('Forgot Password?'),
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
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all( 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Text(
                'Enter your email address below to receive password reset instructions.',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
             
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10), // Add a circular border radius
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword(context, _emailController.text);
                  }
                },
                child: Text('Reset Password', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  padding: EdgeInsets.symmetric(vertical: 14,horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset instructions sent to your email.'),
          ),
        );
      } else if (response.containsKey('status') &&
          response['status'] == 'emailnotfound') {
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

  bool isValidEmail(String email) {
    // Simple email validation regex
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailRegex).hasMatch(email);
  }
}
