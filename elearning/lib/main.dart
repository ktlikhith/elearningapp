import 'dart:convert';

import 'package:elearning/LoginCheckWidget.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/providers/eventprovider.dart';
import 'package:elearning/providers/pastsoonlaterprovider.dart';
import 'package:elearning/providers/profile_provider.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/notification_service.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Notification/notificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //device nav bar and notification bar settings do not remove or comment this*****
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.top,SystemUiOverlay.bottom]);
  

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/eapplogo_foreground');
// Your app icon

  const DarwinInitializationSettings initializationSettingsIOS = 
      DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle the response when a notification is tapped
      _onSelectNotification(response.payload);
    },
  );


  
  

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
   runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => RewardNotifier()),
         ChangeNotifierProvider(create: (_) => HomePageProvider()),
          ChangeNotifierProvider(create: (_) => CourseProvider()),
          ChangeNotifierProvider(create: (_)=> ReportProvider()),
          ChangeNotifierProvider(create: (_)=>ProfileProvider()),
          ChangeNotifierProvider(create: (_)=>activityprovider()),
          ChangeNotifierProvider(create: (_)=>EventProvider()),
          
        
      ],
      child: MyApp(),
    ),
   // MyApp(),
  );

 
}


Future<void> _onSelectNotification(String? payload) async {
  // Navigate to the NotificationScreen directly
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    if(token!=null)
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (context) => NotificationScreen(
        token: token,
      ),
    ),
  );
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context: context,authRepository: AuthRepository()),
      child: GetMaterialApp(
           navigatorKey: navigatorKey,
        title: 'RAP learning',
        theme: ThemeData(
         // primaryColor:Color.fromARGB(255, 10, 36, 114) ,
         //primaryColor: Color(0xFF0A2472),
         primaryColor: Color(0xFF003152),
          //secondaryHeaderColor: Color.fromARGB(255, 26, 67, 191),
          secondaryHeaderColor:Color(0xFF0A2472) ,
          canvasColor:Color(0xFF1A43BF),
          //cardColor:Color.fromARGB(255, 26, 67, 191),
         // cardColor: Color(0xFF1A43BF),
         cardColor: Color(0xFF003152),//this is just for color comb testing !!!!?????
          highlightColor:Colors.white,
          hintColor: Colors.blue[200],

          scaffoldBackgroundColor: Colors.white, // Set the background color for all pages
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
