
import 'dart:ui';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/resetpass_service.dart';
import 'package:elearning/ui/login_page/forgot_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return BlocProvider(
      create: (context) => AuthBloc(context: context, authRepository: authRepository),
      child: _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}


class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //bool _isButtonEnabled = false;

  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
// void _updateButtonState() {
//     setState(() {
//       _isButtonEnabled = _formKey.currentState?.validate() ?? false;
//     });
//   }

  
  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(LoginRequested(username: username, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication failed. Please check your credentials.'),
             
            ),
          );
        }
      },
        child: Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
          key: _formKey,
          //onChanged: _updateButtonState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hi!  Welcome back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 24, // Adjust the width to match the text's size
                    height: 24, // Adjust the height to match the text's size
                    child: SvgPicture.asset(
                      'assets/images/svg/waving-hand-svgrepo-com.svg',
                     
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Let's continue studying to achieve your goals",
                style: TextStyle(fontSize: 16),
                
              ),
              
              SizedBox(height: 50),
             

              Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  
                ),
              ),
              SizedBox(height: 5),
              // Curved border box for username text field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10), // Add a circular border radius
                ),
               
                child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextFormField(
                       
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'username',
                        
                        border: InputBorder.none,
                       
                      ),
                      validator: _usernameValidator,
                    ),
                  ),
                ],
              ),
                
              ),
              SizedBox(height: 20),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                 
                ),
              ),
              SizedBox(height: 5),
              // Curved border box for password text field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10), // Add a circular border radius
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.lock, color: Colors.grey),
                    ),
                    Expanded(
                      child: TextFormField(
                       
                         controller: _passwordController,
                         obscureText: _obscureText,
                        
                        decoration: InputDecoration(
                          hintText: 'password',
                         
                          border: InputBorder.none,
                           suffixIcon: IconButton(
                            icon: Icon(
                             _obscureText ? Icons.visibility_off : Icons.visibility,
                             ),
                             onPressed: _togglePasswordVisibility,
                             ),
                        ),
                         validator: _passwordValidator,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
             
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                              final passwordResetService = PasswordResetService('$Constants.baseUrl');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen(passwordResetService: passwordResetService)),
                              );
                            },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
             
            SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
               onPressed: () => _login(context),
              // onPressed: _isButtonEnabled ? () => _login(context) : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14), // Adjust vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Add a circular border radius
                ),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                 
              ),
             
              
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
            ],
          ),
        ),
        ),
      ),
        ),
    );
  }
}


