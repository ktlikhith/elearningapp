import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:elearning/ui/Dashboard/dashboard.dart';
import 'package:elearning/ui/Gamification/Quiz%20test/quiztest.dart';
import 'package:elearning/ui/Gamification/Quiz/quiz_screens/quiz/quiz_screen.dart';
import 'package:elearning/ui/Gamification/Quiz/quiz_screens/score_screen.dart';
import 'package:elearning/ui/Gamification/gameappbar.dart';
import 'package:elearning/ui/Landingscreen/landingscreen.dart';
import 'package:elearning/ui/Learning_path/learningpath.dart';
import 'package:elearning/ui/Livesession/livesession.dart';
import 'package:elearning/ui/More/bottommore.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';
import 'package:elearning/ui/Reports/reports_chart.dart';

import 'package:elearning/ui/download/download.dart';
import 'package:flutter/material.dart';


class RouterManger{
  static const String homescreen = '/dashboard';
  static const String mylearning = '/mylearning';
  static const String livesession = '/livesession';
  static const String myprofile = '/profile';
  static const String downloads = '/download';
  static const String continuescreen = '/continuescreen';
  static const String morescreen = '/bottommore';
  static const String Gamification = '/gameappbar';
  static const String Report = '/reports_chart';
  static const String landingpage = '/landingscreen';
  static const String Quiz = 'Quiz test/quiztest.dart';
  static const String quizscore ='/score_screen.dart';
  static const String learningpath= '/learningpath.dart';



  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case homescreen:
            final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => DashboardScreen(token: token ), // Pass the token to DashboardScreen
  );
      case mylearning:
     final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => LearningScreen(token: token ),
      );
      case livesession:
      final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => LiveSessionPage(token: token ),
      );

    case myprofile:
     final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => ProfilePage(token: token ),
      );

      
      case downloads:
      return MaterialPageRoute(
        builder:(context) => DownloadPage()
      ,);
    

       case morescreen:
      final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => MyMorePage(token: token ),
      );
      case learningpath:
      final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => LearningPathPage(token: token ),
      );

      case Report:
        final token = settings.arguments as String;
      return MaterialPageRoute(
        builder:(context) => ReportPage(token: token)
      ,);

      case Gamification:
      final token = settings.arguments as String; // Retrieve the token from settings.arguments
        
              return MaterialPageRoute(
          builder: (context) => GamificationPage(token: token),
        
      );
       case quizscore:
      return MaterialPageRoute(
        builder:(context) => ScoreScreen()
      ,);


case Quiz:
      return MaterialPageRoute(
        builder:(context) => QuizPage()
      ,);

      case landingpage:
      return MaterialPageRoute(
        builder:(context) => LandingPage()
      ,);

      default:
      throw const FormatException("Page Not found!!!");
    }
  }
}