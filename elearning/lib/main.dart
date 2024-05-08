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
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 10, 10, 10),
          secondaryHeaderColor: Colors.orange,
          backgroundColor: Colors.white, // Set the background color for all pages
          textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle( // Set the style for app bar title text
              color: Colors.white, // Set your desired color here
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        
         
        ),
        home: LandingPage(),
         onGenerateRoute: RouterManger.generateRoute,
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final String svgCode = '''
  
//   <svg xmlns="http://www.w3.org/2000/svg" fill="#78D6FC" width="24" height="24" viewBox="-0.1 -0.1 16 16" preserveAspectRatio="xMinYMid meet" overflow="visible">
//     <path fill-rule="evenodd" d="M14.96 2.04h.984v4.745h-1.298V3.948h-.89V3.23s.895-.47 1.203-1.192zm.715 4.47V2.309h-.548c-.297.537-.84.912-1.103 1.074v.291h.896v2.838h.755z" clip-rule="evenodd"></path>
//     <path d="M13.873 2.554c-.201.252-.537.386-.537.386l.011.963h-1.136c-1.388 0-2.518 1.164-2.518 2.596 0 1.433 1.13 2.597 2.518 2.597 1.13 0 2.093-.772 2.407-1.841h1.332c-.347 1.813-1.892 3.179-3.75 3.179-2.115 0-3.822-1.763-3.822-3.94s1.712-3.94 3.822-3.94h1.673zm-6.189.397v7.477c0 2.132-1.231 3.403-3.302 3.408H1.914L3.106 12.5h1.276c1.371 0 2.003-.66 2.003-2.065V9.45a3.73 3.73 0 0 1-2.518.985C1.757 10.434.05 8.67.05 6.494s1.707-3.94 3.817-3.934h3.47L6.145 3.897H3.867c-1.388 0-2.518 1.164-2.518 2.597S2.479 9.09 3.867 9.09s2.518-1.164 2.518-2.597L6.38 4.412l1.304-1.46z"></path>
//   </svg>
//   ''';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SVG Code Example',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('SVG Code Example'),
//         ),
//         body: Center(
//           child: SvgPicture.string(
//             svgCode,
//             width: 100,
//             height: 100,
//             color: const Color.fromARGB(255, 10, 10, 10), // Customize color as needed
//           ),
//         ),
//       ),
//     );
//   }
// }
