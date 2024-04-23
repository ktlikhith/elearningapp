import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:elearning/ui/login_page/forgot_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';

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

class GlassContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double sigmaX;
  final double sigmaY;
  final double borderWidth; // New property to adjust border thickness

  const GlassContainer({
    Key? key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.borderWidth = 0.0, // Default border width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: borderRadius,
            // border: Border.all(
            //   color: Colors.black, // Border color
            //   // width: borderWidth, // Border thickness
            // ),
          ),
          child: child,
        ),
      ),
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
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/lgbg0.1.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 246, 244, 244), // Make scaffold background transparent
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 250, horizontal: 50),
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(20.0),
                  borderWidth: 2.0, // Adjust border thickness here
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Color.fromRGBO(18, 18, 18, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Text(
                            "Please login to access and Start Learning",
                            style: TextStyle(
                              color: Color.fromRGBO(16, 16, 16, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(105, 255, 255, 255),
                              border: Border.all(color: Color.fromRGBO(14, 14, 14, 0.686)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(196, 135, 198, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    FadeInUp(
                                      duration: Duration(milliseconds: 1000),
                                      child: TextFormField(
                                        controller: _usernameController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Username",
                                          hintStyle: TextStyle(color: Colors.grey.shade700),
                                        ),
                                        validator: _usernameValidator,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    FadeInUp(
                                      duration: Duration(milliseconds: 1000),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey.shade700),
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
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Color.fromRGBO(62, 50, 221, 1)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: MaterialButton(
                            onPressed: () => _login(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 40,
                            minWidth: double.infinity,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(22),
                                color: Color.fromARGB(255, 13, 12, 12),
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}