import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

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
          tabBackgroundColor: Color.fromARGB(255, 130, 212, 245),
          gap: 5,
          padding: EdgeInsets.all(14),
          tabs: [
            GButton(
              icon: FontAwesomeIcons.house,
              text: 'Home',
              onPressed: () {
                // Handle onPressed for Home tab
                 Navigator.of(context).pushNamed(RouterManger.homescreen);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.graduationCap,
              text: 'Learning',
              onPressed: () {
                // Handle onPressed for Learning tab
                 Navigator.of(context).pushNamed(RouterManger.mylearning);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.bookOpen,
              text: 'Live',
              onPressed: () {
                // Handle onPressed for Live tab
               Navigator.of(context).pushNamed(RouterManger.livesession);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.trophy,
              text: 'Game',
              onPressed: () {
                // Handle onPressed for Game tab
               Navigator.of(context).pushNamed(RouterManger.Gamification);
              },
            ),
            GButton(
              icon: FontAwesomeIcons.ellipsis,
              text: 'More',
              onPressed: () {
                // Handle onPressed for More tab
                print('More tab pressed');
              },
            ),
          ],
          // selectedIndex: 0, // Set the initial selected tab index here
          // onTabChange: (index) {
          //   // Handle tab change events here, if needed
          //   // You can use this callback to update the UI or navigate to different screens
          // },
        ),
      ),
    );
  }
}
