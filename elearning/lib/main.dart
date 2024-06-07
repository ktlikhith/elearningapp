import 'package:elearning/LoginCheckWidget.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Landingscreen/landingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context: context,authRepository: AuthRepository()),
      child: GetMaterialApp(
        title: 'E learning',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 10, 10, 10),
          secondaryHeaderColor: Colors.orange,
          backgroundColor: Colors.grey[100], // Set the background color for all pages
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            titleTextStyle: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20, // Set your desired font size
              ),
            ),
          ),
        ),
        home: LoginCheckWidget(), // Use LoginCheckWidget to perform login check
        onGenerateRoute: RouterManger.generateRoute,
      ),
    );
  }
}
