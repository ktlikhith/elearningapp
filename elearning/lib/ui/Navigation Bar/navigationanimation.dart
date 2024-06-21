
// import 'dart:async';
// import 'package:circle_nav_bar/circle_nav_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:elearning/routes/routes.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final int initialIndex;
//   final String token;

//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.initialIndex,
//     required this.token,
//   }) : super(key: key);

//   @override
//   _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   late int _selectedIndex;
//   Timer? _timer; // Define _timer as a Timer variable

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex ?? 0; // Use initialIndex if provided
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer
//     super.dispose();
//   }

//   @override
//  Widget build(BuildContext context) {
//   return Container(
//       child: Padding(
     
//      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),

//         child:  CircleNavBar(
//         activeIcons: [
//           Icon(FontAwesomeIcons.house, color: Colors.black),
//           Icon(FontAwesomeIcons.graduationCap, color: Colors.black),
//           Icon(FontAwesomeIcons.bookOpen, color: Colors.black),
//           Icon(FontAwesomeIcons.trophy, color: Colors.black),
//           Icon(FontAwesomeIcons.ellipsis, color: Colors.black),
//         ],
//         inactiveIcons: [
//           Text(,"Home"),
//           Text("Learning"),
//           Text("Live"),
//           Text("Game"),
//           Text("More"),
//         ],
//         color: Colors.grey[300]!,
//         circleColor: Colors.grey[300],
//         height: 60,
//         circleWidth: 60,
//         onTap: _handleTabPressed,
//         activeIndex: _selectedIndex,
//         tabCurve: Curves.easeOutExpo,
//         padding: const EdgeInsets.all(8),
//         cornerRadius: const BorderRadius.vertical(top: Radius.circular(15)),
//         shadowColor: Colors.black45,
//         elevation: 10,
//       ),
         
         
//         ),
      
    
//   );
// }


//   void _handleTabPressed(int index) {
//     if (!mounted) return; // Check if the state is still mounted

//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
//         break;
//       case 1:
//         Navigator.of(context).pushReplacementNamed(RouterManger.mylearning, arguments: widget.token);
//         break;
//       case 2:
//         Navigator.of(context).pushReplacementNamed(RouterManger.livesession, arguments: widget.token);
//         break;
//       case 3:
//         Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
//         break;
//       case 4:
//         Navigator.of(context).pushReplacementNamed(RouterManger.morescreen, arguments: widget.token);
//         break;
//     }
//   }
// }
import 'dart:async';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:elearning/routes/routes.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final String token;

  const CustomBottomNavigationBar({
    Key? key,
    required this.initialIndex,
    required this.token,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;
  Timer? _timer; // Define _timer as a Timer variable

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Use initialIndex if provided
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: CircleNavBar(
          activeIcons: [
            Icon(FontAwesomeIcons.house, color: Colors.black),
            Icon(FontAwesomeIcons.graduationCap, color: Colors.black),
            Icon(FontAwesomeIcons.bookOpen, color: Colors.black),
            Icon(FontAwesomeIcons.trophy, color: Colors.black),
            Icon(FontAwesomeIcons.ellipsis, color: Colors.black),
          ],
          inactiveIcons: [
            _buildInactiveItem(FontAwesomeIcons.house, "Home"),
            _buildInactiveItem(FontAwesomeIcons.graduationCap, "Learning"),
            _buildInactiveItem(FontAwesomeIcons.bookOpen, "Live"),
            _buildInactiveItem(FontAwesomeIcons.trophy, "Game"),
            _buildInactiveItem(FontAwesomeIcons.ellipsis, "More"),
          ],
          color: Colors.grey[300]!,
          circleColor: Colors.grey[300],
          height: 60,
          circleWidth: 60,
          onTap: _handleTabPressed,
          activeIndex: _selectedIndex,
          tabCurve: Curves.easeOutExpo,
          padding: const EdgeInsets.all(8),
          cornerRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          shadowColor: Colors.black45,
          elevation: 10,
        ),
      ),
    );
  }

  Widget _buildInactiveItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  void _handleTabPressed(int index) {
    if (!mounted) return; // Check if the state is still mounted

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(RouterManger.mylearning, arguments: widget.token);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(RouterManger.livesession, arguments: widget.token);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed(RouterManger.morescreen, arguments: widget.token);
        break;
    }
  }
}
