import 'package:elearning/ui/Dashboard/dashboard.dart';
import 'package:elearning/ui/Livesession/livesession.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';
import 'package:elearning/ui/Q&A_page/questionandanswer.dart';
import 'package:elearning/ui/download/download.dart';
import 'package:flutter/material.dart';


class RouterManger{
  static const String homescreen ='/';
  static const String mylearning ='/ui/My_learning/mylearning.dart';
  static const String livesession ='/ui/Livesession/livesession.dart';
  static const String myprofile ='/ui/Profile/profile.dart';
  static const String Askexpert='/ui/Q&A_page/questionandanswer.dart';
  static const String downloads='/ui/Download/download.dart';


  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case homescreen:
      return MaterialPageRoute(
        builder:(context) => DashboardScreen()
      ,);
      case mylearning:
      return MaterialPageRoute(
        builder:(context) => MyLearningApp()
      ,);
      case livesession:
      return MaterialPageRoute(
        builder:(context) => LiveSessionPage( courseTitle: 'Flutter Development Masterclass',
      speakerName: 'Jane Doe',
      duration: '1h 30m - 3h',
      mode: 'Online',
      sessionAddress: 'https://example.com/live-session-link',
      description: '''
        Join us for an exciting journey into Flutter development.
        Learn to build beautiful, responsive apps with Flutter!
      ''',)
    );

    case myprofile:
      return MaterialPageRoute(
        builder:(context) => ProfileApp()
      ,);

      case Askexpert:
      return MaterialPageRoute(
        builder:(context) => QuestionAnswersPage()
      ,);
      case downloads:
      return MaterialPageRoute(
        builder:(context) => DownloadPage()
      ,);

      default:
      throw FormatException("Page Not found!!!");
    }
  }
}