import 'package:elearning/ui/Dashboard/continuescreen.dart';
import 'package:elearning/ui/Dashboard/dashboard.dart';
import 'package:elearning/ui/Gamification/gameappbar.dart';
import 'package:elearning/ui/Livesession/livesession.dart';
import 'package:elearning/ui/More/bottommore.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Profile/profile.dart';
import 'package:elearning/ui/Q&A_page/questionandanswer.dart';
import 'package:elearning/ui/download/download.dart';
import 'package:flutter/material.dart';


class RouterManger{
  static const String homescreen = '/dashboard';
  static const String mylearning = '/mylearning';
  static const String livesession = '/livesession';
  static const String myprofile = '/profile';
  static const String Askexpert = '/questionandanswer';
  static const String downloads = '/download';
  static const String continuescreen = '/continuescreen';
  static const String morescreen = '/bottommore';
  static const String Gamification = '/gameappbar';



  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case homescreen:
            final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => DashboardScreen(token: token ), // Pass the token to DashboardScreen
  );
      case mylearning:
      return MaterialPageRoute(
        builder:(context) => const MyLearningApp()
      ,);
      case livesession:
      return MaterialPageRoute(
        builder:(context) => const LiveSessionPage( courseTitle: 'Flutter Development Masterclass',
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
     final token = settings.arguments as String; // Retrieve the token from settings.arguments
            return MaterialPageRoute(
            builder: (context) => ProfilePage(token: token ),
      );

      case Askexpert:
      return MaterialPageRoute(
        builder:(context) => const QuestionAnswersPage()
      ,);
      case downloads:
      return MaterialPageRoute(
        builder:(context) => DownloadPage()
      ,);
      case continuescreen:
      return MaterialPageRoute(
        builder:(context) => ContinueWatchingScreen(
      items: List.generate(
        5,
        (index) => ContinueWatchingItem(
          title: 'Title $index',
          imageUrl: 'https://via.placeholder.com/150',
          lastWatched: '2 hours ago',
          onTap: () {
            print('Item $index tapped');
          },
        ),
      ),
    ),
      );

       case morescreen:
      return MaterialPageRoute(
        builder:(context) => MyMorePage()
      ,);


      case Gamification:
      return MaterialPageRoute(
        builder:(context) => GamificationPage()
      ,);
      default:
      throw const FormatException("Page Not found!!!");
    }
  }
}