import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ElearningApp());
}

class ElearningApp extends StatelessWidget {
  const ElearningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orangeAccent, // Set the primary color for the app bar
        backgroundColor: Colors.white, // Set the background color for all pages
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: RouterManger.homescreen,
      onGenerateRoute: RouterManger.generateRoute,
      
    );
  }
}
