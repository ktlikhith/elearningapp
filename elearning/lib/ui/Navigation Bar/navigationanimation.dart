import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavigationBar({Key? key, required this.initialIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 18),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Theme.of(context).primaryColor,
          gap: 5,
          padding: EdgeInsets.all(14),
          tabs: [
            GButton(
              icon: FontAwesomeIcons.house,
              text: 'Home',
              onPressed: () {
                _handleTabPressed(0);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.graduationCap,
              text: 'Learning',
              onPressed: () {
                _handleTabPressed(1);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.bookOpen,
              text: 'Live',
              onPressed: () {
                _handleTabPressed(2);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.trophy,
              text: 'Game',
              onPressed: () {
                _handleTabPressed(3);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.ellipsis,
              text: 'More',
              onPressed: () {
                _handleTabPressed(4);
              },
            ),
          ],
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  void _handleTabPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(RouterManger.homescreen);
        break;
      case 1:
        Navigator.of(context).pushNamed(RouterManger.mylearning);
        break;
      case 2:
        Navigator.of(context).pushNamed(RouterManger.livesession);
        break;
      case 3:
        Navigator.of(context).pushNamed(RouterManger.Gamification);
        break;
      // case 4:
      //   Navigator.of(context).pushNamed(RouterManger.morescreen);
      //   break;
    }
  }
}
