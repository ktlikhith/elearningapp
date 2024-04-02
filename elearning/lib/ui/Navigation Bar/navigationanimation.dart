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
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        if (_selectedIndex != 0) {
          _handleTabPressed(0); // Assuming index 0 is for the Home tab
          return false; // Prevent default behavior (pop navigation)
        }
        return true; // Allow default behavior (pop navigation)
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 18),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Color.fromARGB(255, 130, 212, 245),
            gap: 5,
            padding: EdgeInsets.all(14),
            tabs: [
              GButton(
                icon: FontAwesomeIcons.house,
                text: 'Home',
                onPressed: () {
                  _handleTabPressed(0);
                  Navigator.of(context).pushNamed(RouterManger.homescreen);
                },
              ),
              GButton(
                icon: FontAwesomeIcons.graduationCap,
                text: 'Learning',
                onPressed: () {
                  _handleTabPressed(1);
                  Navigator.of(context).pushNamed(RouterManger.mylearning);
                },
              ),
              GButton(
                icon: FontAwesomeIcons.bookOpen,
                text: 'Live',
                onPressed: () {
                  _handleTabPressed(2);
                  Navigator.of(context).pushNamed(RouterManger.livesession);
                },
              ),
              GButton(
                icon: FontAwesomeIcons.trophy,
                text: 'Game',
                onPressed: () {
                  _handleTabPressed(3);
                  Navigator.of(context).pushNamed(RouterManger.Gamification);
                },
              ),
              GButton(
                icon: FontAwesomeIcons.ellipsis,
                text: 'More',
                onPressed: () {
                  _handleTabPressed(4);
                  print('More tab pressed');
                },
              ),
            ],
            selectedIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }

  void _handleTabPressed(int index) {
  setState(() {
    if (index != _selectedIndex) {
      // Update the selected index only if it's different from the current index
      _selectedIndex = index;
      switch (index) {
        case 0: // Home tab
          Navigator.of(context).pushNamed(RouterManger.homescreen);
          break;
        case 1: // Learning tab
          Navigator.of(context).pushNamed(RouterManger.mylearning);
          break;
        case 2: // Live tab
          Navigator.of(context).pushNamed(RouterManger.livesession);
          break;
        case 3: // Game tab
          Navigator.of(context).pushNamed(RouterManger.Gamification);
          break;
        case 4: // More tab
          print('More tab pressed');
          break;
        default:
        Navigator.of(context).pushNamed(RouterManger.homescreen);
          break;
      }
    } else if (index == 0) {
      // Handle back navigation if Home tab is already selected
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  });
}
}
