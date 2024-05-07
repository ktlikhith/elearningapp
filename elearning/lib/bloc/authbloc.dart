import 'package:elearning/repositories/authrepository.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elearning/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

// Define states
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token; // Define a token property

  AuthAuthenticated(this.token); // Constructor to initialize token
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}



// Define AuthBloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BuildContext context;
  final AuthRepository authRepository;

  AuthBloc({required this.context, required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Emit loading state while performing authentication
    try {
      final result = await authRepository.login(event.username, event.password);
      final token = result['token'];
       // Replace with actual token from backend
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('token', token); // Assuming login returns token
      //print(token);
      emit(AuthAuthenticated(token));// Emit authenticated state on successful login
     
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);
    } catch (error) {
      emit(AuthFailure(message: 'Authentication failed')); // Emit failure state with error message
      print('Authentication failed: $error'); // Print error message to the terminal
    }
    // This function clears the user session or token


  }


 


}
