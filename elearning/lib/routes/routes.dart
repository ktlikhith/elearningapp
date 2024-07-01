import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:elearning/ui/Dashboard/dashboard.dart';
import 'package:elearning/ui/Gamification/Quiz%20test/quiztest.dart';

import 'package:elearning/ui/Gamification/gameappbar.dart';
import 'package:elearning/ui/Landingscreen/landingscreen.dart';
import 'package:elearning/ui/Learning_path/learningpath.dart';
import 'package:elearning/ui/Livesession/livesession.dart';
import 'package:elearning/ui/More/bottommore.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';
import 'package:elearning/ui/Reports/Learning_Report/learning_path.dart';
import 'package:elearning/ui/Reports/My_course_progress/each_course_progress.dart';
import 'package:elearning/ui/Reports/My_course_progress/my_course_progress.dart';

import 'package:elearning/ui/Reports/reports_chart.dart';
import 'package:elearning/ui/download/download_screen.dart';
import 'package:flutter/material.dart';


class RouterManger{
  static const String landingscreen= '/landingscreen';
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
  static const String mycourseprogress='/my_course_progress.dart';
  static const String eachcourseprogress='/each_course_progress.dart';
  static const String learningprogress='/learning_path.dart';



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
       final token = settings.arguments as String;
      return MaterialPageRoute(
        builder:(context) => DownloadsScreen(token: token)
      ,);
       case landingscreen:
       
      return MaterialPageRoute(
        builder:(context) => LandingPage()
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
      case mycourseprogress:
final token = settings.arguments as String; 
      return MaterialPageRoute(
        builder:(context) => Coursereport(token: token)
      ,);
     
case learningprogress:
final token = settings.arguments as String; 
      return MaterialPageRoute(
        builder:(context) => LearningPathScreen(token: token)
      ,);

case eachcourseprogress:
final token = settings.arguments as String; 
      return MaterialPageRoute(
        builder:(context) => CourseProgressPage(token: token)
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