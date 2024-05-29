
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
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
    _selectedIndex = widget.initialIndex ?? 0; // Use initialIndex if provided
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

        child: FloatingNavbar(
          fontSize: 12,
          iconSize: 26,
        
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(255, 17, 17, 17),
          unselectedItemColor: Color.fromARGB(255, 149, 147, 147),
          // selectedBackgroundColor: Theme.of(context).secondaryHeaderColor,
          onTap: _handleTabPressed,
          currentIndex: _selectedIndex,
          itemBorderRadius: 9,
          borderRadius: 9,
          margin: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
          padding: EdgeInsets.only(bottom: 0,top: 0),
          
            
         
          items: [
            FloatingNavbarItem(
              icon: FontAwesomeIcons.house,
              title: 'Home',
              
              
            ),
            FloatingNavbarItem(
              icon: FontAwesomeIcons.graduationCap,
              title: 'Learning',
            ),
            FloatingNavbarItem(
              icon: FontAwesomeIcons.bookOpen,
              title: 'Live',
            ),
            FloatingNavbarItem(
              icon: FontAwesomeIcons.trophy,
              title: 'Game',
            ),
            FloatingNavbarItem(
              icon: FontAwesomeIcons.ellipsis,
              title: 'More',
            ),
          ],
        ),
      ),
    
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
