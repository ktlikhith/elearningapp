import 'package:elearning/LoginCheckWidget.dart';
import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/repositories/authrepository.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/rewarddata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //device nav bar and notification bar settings do not remove or comment this*****
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.top,SystemUiOverlay.bottom]);
  

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
   runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => RewardNotifier()),
          ChangeNotifierProvider(create: (_) => RewardProvider()),
        
      ],
      child: MyApp(),
    ),
  );

 
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(context: context,authRepository: AuthRepository()),
      child: GetMaterialApp(
        title: 'E learning',
        theme: ThemeData(
         // primaryColor:Color.fromARGB(255, 10, 36, 114) ,
         primaryColor: Color(0xFF0A2472),
          //secondaryHeaderColor: Color.fromARGB(255, 26, 67, 191),
          secondaryHeaderColor:Color(0xFF0A2472) ,
          //cardColor:Color.fromARGB(255, 26, 67, 191),
          cardColor: Color(0xFF1A43BF),
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
