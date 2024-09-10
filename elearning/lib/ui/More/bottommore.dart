// import 'dart:convert';

// import 'package:elearning/routes/routes.dart';

// import 'package:elearning/services/profile_service.dart';
// import 'package:elearning/ui/Learning_path/learningpath.dart';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyMorePage extends StatefulWidget {
//   final String token;

//   const MyMorePage({Key? key, required this.token}) : super(key: key);

//   @override
//   _MyMorePageState createState() => _MyMorePageState();
// }

 
// class _MyMorePageState extends State<MyMorePage> {
//    late String _profilePictureUrl = '';

//    @override
//   void initState() {
//     super.initState();
//     _fetchProfileData(widget.token);
//   }
//   Future<void> _clearToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('token');
//   // Navigate back to the landing page or login screen if needed
// }

//   Future<void> _fetchProfileData(String token) async {
//     try {
//       final data = await ProfileAPI.fetchProfileData(token);
//       setState(() {
//         final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
//         if (profilePictureMatch != null) {
//           _profilePictureUrl = profilePictureMatch.group(1)!;
//         }
//       });
//     } catch (e) {
//       print('Error fetching profile data: $e');
//     }
//   }
  


//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('More Page'),
//            centerTitle: false,
//            leading: IconButton(
//           icon: Icon(Icons.arrow_back,color: Colors.white,),
//           onPressed: () {
//             Navigator.of(context).pushReplacementNamed(RouterManger.homescreen,arguments: widget.token);
//           },
//         ),
//           backgroundColor: Theme.of(context).primaryColor,
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
//                 },
//                 child: CircleAvatar(
//                   radius: 20,
//                  backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Theme.of(context).backgroundColor,
//        body: ListView(
//         children: <Widget>[
//           InkWell(
//             onTap: () {
//               Navigator.of(context).pushNamed(RouterManger.learningpath, arguments: widget.token);
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: ListTile(
//               leading: FaIcon(FontAwesomeIcons.graduationCap),
//               title: Text('Learning Path'),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.of(context).pushNamed(RouterManger.Report, arguments: widget.token);
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: ListTile(
//               leading: FaIcon(FontAwesomeIcons.chartSimple),
//               title: Text('Reports'),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//                 Navigator.of(context).pushNamed(RouterManger.downloads,arguments: widget.token);
//                 print("download selected");
//               // Implement downloads functionality here
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: ListTile(
//               leading: FaIcon(FontAwesomeIcons.download),
//               title: Text('Downloads'),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               _clearToken();
//               Navigator.of(context).pushReplacementNamed(RouterManger.landingpage);
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: ListTile(
//               leading: FaIcon(FontAwesomeIcons.rightFromBracket),
//               title: Text('Logout'),
//             ),
//           ),
          
//         ],
//       ),

//       ),
//     );
//   }


  
// }

// import 'dart:convert';

// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/profile_service.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyMorePage extends StatefulWidget {
//   final String token;

//   const MyMorePage({Key? key, required this.token}) : super(key: key);

//   @override
//   _MyMorePageState createState() => _MyMorePageState();
// }

// class _MyMorePageState extends State<MyMorePage> {
//   late String _profilePictureUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData(widget.token);
//   }

//   Future<void> _clearToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     // Navigate back to the landing page or login screen if needed
//   }

//   Future<void> _fetchProfileData(String token) async {
//     try {
//       final data = await ProfileAPI.fetchProfileData(token);
//       setState(() {
//         final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
//         if (profilePictureMatch != null) {
//           _profilePictureUrl = profilePictureMatch.group(1)!;
//         }
//       });
//     } catch (e) {
//       print('Error fetching profile data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('More', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           centerTitle: false,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
//             },
//           ),
//           backgroundColor: Theme.of(context).primaryColor,
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
//                 },
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
//                   backgroundColor: Colors.grey[200],
//                   child: _profilePictureUrl.isEmpty ? Icon(Icons.person, color: Colors.grey[600]) : null,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: ListView(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//           children: <Widget>[
//             _buildListTile(
//               icon: FontAwesomeIcons.graduationCap,
//               text: 'Learning Path',
//               onTap: () => Navigator.of(context).pushNamed(RouterManger.learningpath, arguments: widget.token),
//             ),
//             Divider(),
//             _buildListTile(
              // icon: FontAwesomeIcons.chartSimple,
              // text: 'Reports',
              // onTap: () => Navigator.of(context).pushNamed(RouterManger.Report, arguments: widget.token),
//             ),
//             Divider(),
//             _buildListTile(
              // icon: FontAwesomeIcons.download,
              // text: 'Downloads',
              // onTap: () {
              //   Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);
              //   print("download selected");
              // },
//             ),
//             Divider(),
//             _buildListTile(
//               icon: FontAwesomeIcons.rightFromBracket,
//               text: 'Logout',
//               onTap: () {
//                 _clearToken();
//                 Navigator.of(context).pushReplacementNamed(RouterManger.landingpage);
//               },
//             ),
//               Divider(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildListTile({required IconData icon, required String text, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       splashColor: Colors.transparent,
//       highlightColor: Colors.transparent,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         child: Row(
//           children: <Widget>[
//             FaIcon(icon, color: Theme.of(context).primaryColor),
//             SizedBox(width: 20),
//             Text(text, style: TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';

import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/profile_service.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/utilites/alertdialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMorePage extends StatefulWidget {
  final String token;

  const MyMorePage({Key? key, required this.token}) : super(key: key);

  @override
  _MyMorePageState createState() => _MyMorePageState();
}

class _MyMorePageState extends State<MyMorePage> {
  late String _profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchProfileData(widget.token);
  }
 void ShowLogoutdialog(BuildContext context){
  showDialog(context: context, 
  builder:(context) {
    return AlertDialog(
      title: Center(
        child: Text('Are you sure you  want to logout?',textAlign:TextAlign.center, style: GoogleFonts.lato(
                 fontSize: 20,fontWeight: FontWeight.bold
                ),
        ),
      ),
     
      actions: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             TextButton(
              
              onPressed: (){
                
                  Navigator.of(context).pushReplacementNamed(RouterManger.landingpage);
                      _clearToken();
                     
              }, child: Text('Yes, Logout',style: TextStyle(fontSize: 18,color: Theme.of(context).cardColor,fontWeight: FontWeight.bold)),),
              TextButton(
          onPressed: (){
            
            Navigator.of(context).pop();
          }, child: Text('No',style: TextStyle(fontSize: 18,color: Theme.of(context).cardColor,fontWeight: FontWeight.bold)),),
           ],
         ),
           
      ],
    );
    
  },);
}

  Future<void> _clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // Navigate back to the landing page or login screen if needed
  }

  Future<void> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      setState(() {
        final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
        if (profilePictureMatch != null) {
          _profilePictureUrl = profilePictureMatch.group(1)!;
        }
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('More', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
                  backgroundColor: Colors.grey[200],
                  child: _profilePictureUrl.isEmpty ? Icon(Icons.person, color: Colors.grey[600]) : null,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: <Widget>[
              _buildCard(
             color:Color(0xFF3ACBE8),
           icon: Icons.person,
              text: 'My Profile',
              onTap: () => Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token),
            ),
         
            _buildCard(
             color:Color(0xFF1CA3DE),
           icon: FontAwesomeIcons.graduationCap,
              text: 'Learning Path',
              onTap: () => Navigator.of(context).pushNamed(RouterManger.learningpath, arguments: widget.token),
            ),
        
            _buildCard(
               color:Color(0xFF0D85D8),
                          icon: FontAwesomeIcons.download,
              text: 'Downloads',
              onTap: () {
                Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);
              
              },
            ),
             _buildCard(
               color:Color(0xFF0160C9),
                          icon: FontAwesomeIcons.chartSimple,
              text: 'Reports',
              onTap: () {
                 Navigator.of(context).pushNamed(RouterManger.Report, arguments: widget.token);
              
              },
            ),
              _buildCard(
               color:Color.fromARGB(255, 16, 79, 204),
                          icon: FontAwesomeIcons.certificate,
              text: 'Certificates',
              onTap: 
                 () {
                            Navigator.of(context).pushNamed(RouterManger.certificatereport, arguments: widget.token);
                          
              
              },
            ),
            _buildCard(
               color:Color(0xFF0041C7),
             icon: FontAwesomeIcons.rightFromBracket,
              text: 'Logout',
              onTap: () {
            
                ShowLogoutdialog(context);
              
              }
            ),
          ],
        ),
         bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 5, token: widget.token),
      ),
    );
  }

// Widget _buildCard({required IconData icon, required String text,  required VoidCallback onTap}) {
//   return Container(
    
//     //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//     decoration: BoxDecoration(border: Border.all(color: Theme.of(context).cardColor),borderRadius: BorderRadius.circular(8), color:Theme.of(context).hintColor.withOpacity(0.2)),
//     margin: EdgeInsets.symmetric(vertical: 10),
//     // color: Colors.grey[100],
//     //elevation: 3,
//     child:SizedBox(
//       height: 80,
//     child: ListTile(
//       contentPadding: EdgeInsets.symmetric(vertical: 13,horizontal: 10),
//       onTap: onTap,
//       leading: Icon(icon, color: Theme.of(context).cardColor),
//       title: Text(text, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
//       //subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
//       trailing: 
//       //CircleAvatar(
//         //radius: 13,
//         //backgroundColor: Theme.of(context).hintColor,
//         //child:
//          Icon(Icons.arrow_forward_ios, size: 20, color: Theme.of(context).cardColor),
//      // ),
//     ),
//     ),
   
//   );
// }

Widget _buildCard({required Color color, required IconData icon, required String text, required VoidCallback onTap}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
    ),
    child:SizedBox( height: 80,
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      trailing: Icon(Icons.more_horiz, color: Colors.white),
    ),
    ),
  );
}
}
