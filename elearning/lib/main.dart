import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';

import 'package:elearning/ui/Gamification/gameappbar.dart';

import 'package:flutter/material.dart';
import 'package:elearning/ui/Dashboard/dashboard.dart';


void main() {
  runApp(ElearningApp());
}

class ElearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'E-Learning App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      initialRoute: RouterManger.homescreen,
      onGenerateRoute: RouterManger.generateRoute,
    );
  }

   


}
// smaple data for live seesion code
// import 'package:elearning/ui/livesession/livesession.dart';
// import 'package:flutter/material.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Moodle Login',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home:LiveSessionPage( courseTitle: 'Flutter Development Masterclass',
//       speakerName: 'Jane Doe',
//       duration: '1h 30m - 3h',
//       mode: 'Online',
//       sessionAddress: 'https://example.com/live-session-link',
//       description: '''
//         Join us for an exciting journey into Flutter development.
//         Learn to build beautiful, responsive apps with Flutter!
//       ''',
//     ),
//   );
// }
// }
