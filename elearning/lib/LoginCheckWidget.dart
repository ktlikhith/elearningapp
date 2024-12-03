
import 'dart:async';
import 'dart:io';

import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/utilites/notificationinitialise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class LoginCheckWidget extends StatefulWidget {
  @override
  _LoginCheckWidgetState createState() => _LoginCheckWidgetState();
}

class _LoginCheckWidgetState extends State<LoginCheckWidget> {
  bool _isLoggedIn = false;
   NotificationHandler notefy=new NotificationHandler();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3)); // Add delay to show splash screen

    String updateRequired = await _checkForUpdate();
    if (updateRequired != "false") {
      // Show update dialog
      _showUpdateDialog(updateRequired);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
    });

    if (_isLoggedIn) {
       await context.read<HomePageProvider>().fetchAllCourses();
          await Provider.of<ReportProvider>(context, listen: false).fetchData();
  //      WidgetsBinding.instance.addPostFrameCallback((_) {
  //   context.read<HomePageProvider>().fetchAllCourses();
   
  // });
      // notifications initiliser
       Future.delayed(Duration(seconds: 5),(){
       
           
  const duration = Duration(seconds: 10); // Adjust the interval as needed
  Timer.periodic(duration, (timer) async {
    if(token!=null)
    await notefy.fetchNotifications(token);
  });

       });
   

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: token);

    

    } else {
      // No token, navigate to LandingPage
      Navigator.of(context).pushReplacementNamed(RouterManger.landingscreen);
    }
  }

  Future<String> _checkForUpdate() async {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String currentVersion = packageInfo.version;
    String latestVersion = "1.0.0";
    String update_android_link="hi";
    String update_ios_link="hello";

    if (currentVersion.compareTo(latestVersion) < 0) {
      if(Platform.isAndroid){
        return update_android_link;
      }
        else {
          return update_ios_link;
        }

      
        
      }else{
        return('false');
      }

    // final response = await http.get(Uri.parse('https://yourapi.com/update-status'));

    // if (response.statusCode == 200) {
    //   var data = json.decode(response.body);
    //   String latestVersion = data['latest_version'];
    //   String updateLink = data['update_link'];
    //   if (currentVersion.compareTo(latestVersion) < 0) {
    //     return updateLink;
    //   }
    // } else {
    //   // Handle error
    //   print('Failed to fetch update status');
    // }
    // return "false";
  }

  void _showUpdateDialog(String updateLink) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Available'),
          content: Text('A new version of the app is available. Please update to continue.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                // Close the app
                 SystemNavigator.pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              

                  onPressed: () async {
                // Open the app store or play store link based on the platform
              
               
                if (await canLaunch(updateLink)) {
                  await launch(updateLink);
                } else {
                  print('Could not launch $updateLink');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(),
    );
  }
}




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
 SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Animation controller for the waves animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: false);

    // Animation for the circular waves
    _animation = Tween<double>(begin: 0, end: 600).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = MediaQuery.of(context).size.height * 0.18;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color(0xFF0041C7),
        //       Color(0xFF0D85D8),
        //       Color(0xFF3ACBE8),
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular wave effect
            Image.asset(
                  'assets/logo/spalsh bg01.jpg',
                  fit:BoxFit.fitHeight,
                //  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                ),
            Container(
              width: _animation.value, // Expands over time
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.withOpacity(0.3), // Semi-transparent waves
              ),
            ),
            Container(
              width: _animation.value * 0.7, // Second wave
              height: _animation.value * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.withOpacity(0.4),
              ),
            ),
            Container(
              width: _animation.value * 0.4, // Third wave
              height: _animation.value * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.withOpacity(0.6),
              ),
            ),
            // 3D elevated logo
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow for 3D effect
                    blurRadius: 20,
                    offset: Offset(0, 6), // Shadow below the logo
                  ),
                ],
              ),
              child: Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.022),
                child: Image.asset(
                  'assets/logo/eapplogo (1) (1).png',
                  width: logoSize,
                ),
              ),
            ),
             Padding(
               padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.13,left: MediaQuery.of(context).size.width*0.02),
               child: Text("RAPID ACCESS PLATFORM",
               style: GoogleFonts.acme(color: const Color.fromARGB(255, 1, 29, 78),fontWeight: FontWeight.w900 ,fontSize: 13,),
              // style: TextStyle(color: const Color.fromARGB(255, 1, 29, 78),fontWeight: FontWeight.w900 ,fontSize: 13,),
               ),
             ),
          ],
        ),
      ),
    );
  }
}

