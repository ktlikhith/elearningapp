import 'package:animate_do/animate_do.dart';
import 'package:elearning/ui/login_page/forgot_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository(); // Create an instance of AuthRepository
    return BlocProvider(
      create: (context) => AuthBloc(context: context, authRepository: authRepository), // Provide AuthRepository to AuthBloc
      child: _LoginScreenContent(), // Use _LoginScreenContent as child
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
    // You can add more validation logic here if needed
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add more validation logic here if needed
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

      // Access the AuthBloc using BlocProvider.of
      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(LoginRequested(username: username, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: FadeInUp(
                      duration: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: 400,
                    width: MediaQuery.of(context).size.width + 20,
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background-2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
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
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Color.fromRGBO(196, 135, 198, .3)),
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
                                duration: Duration(milliseconds: 1900),
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
                                duration: Duration(milliseconds: 1900),
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
                      duration: Duration(milliseconds: 1900),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 30),
FadeInUp(
  duration: Duration(milliseconds: 1900),
  child: MaterialButton(
    onPressed: () => _login(context),
    // color: const Color.fromARGB(243, 255, 86, 34),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    height: 40, // Increased button height
    minWidth: double.infinity, // Button fills available width
    child: Container(
      height: 40, // Adjusted container height
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFA000),
            Color(0xFFD500F9),
            // Replace with your desired gradient colors
          ],
        ),
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
          ],
        ),
      ),
    );
  }
}