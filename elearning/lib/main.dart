// import 'package:elearning/constants.dart';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/ui/login_page/login_screen%20.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(const ElearningApp());
// }

// class ElearningApp extends StatelessWidget {
//   const ElearningApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//                 scaffoldBackgroundColor: Colors.white,
//         primarySwatch: Colors.blue,
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 48),
//             backgroundColor: Color.fromARGB(255, 246, 144, 55),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//               side: BorderSide.none,
//             ),
//             elevation: 0,
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           fillColor: Color.fromARGB(198, 243, 232, 232),
//           filled: true,
//           border: defaultOutlineInputBorder,
//           enabledBorder: defaultOutlineInputBorder,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: Color.fromARGB(255, 241, 134, 41)),
//           ),
//         ),
//         // primaryColor: Colors.orangeAccent, // Set the primary color for the app bar
//         // backgroundColor: Colors.white, // Set the background color for all pages
//         // textTheme: GoogleFonts.robotoTextTheme(
//         //   Theme.of(context).textTheme,
//         // ),
//       ),
//       // initialRoute: RouterManger.homescreen,
//       // onGenerateRoute: RouterManger.generateRoute,
//       home: LoginScreen(),
      
//     );
//   }
// }


import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context: context,authRepository: AuthRepository()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromARGB(230, 249, 78, 26),
          backgroundColor: Colors.white, // Set the background color for all pages
          textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,

        ),
        ),
        home: LoginScreen(),
        onGenerateRoute: RouterManger.generateRoute, 
      ),
    );
  }
}

