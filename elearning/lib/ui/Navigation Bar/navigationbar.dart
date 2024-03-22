import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Gamification/gameappbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.house),
              onPressed: () {
                Navigator.of(context).pushNamed(RouterManger.homescreen);
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.graduationCap),
              onPressed: () {
                Navigator.of(context).pushNamed(RouterManger.mylearning);
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.bookOpen),
              onPressed: () {
                Navigator.of(context).pushNamed(RouterManger.livesession);
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.trophy),
              onPressed: () {
                Navigator.of(context).pushNamed(RouterManger.Gamification);
              },
            ),
            EllipsisMenuItems(),
          ],
        ),
      ),
    );
  }
}

class EllipsisMenuItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: FaIcon(FontAwesomeIcons.ellipsis),
      offset: Offset(30, 120), // Adjust offset to move the menu above the bottom navigation bar
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(FontAwesomeIcons.download),
            title: Text('Download'),
            onTap: () {
             Navigator.of(context).pushNamed(RouterManger.downloads);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            title: Text('Logout'),
            onTap: () {
              // Handle logout tap
            },
          ),
        ),
      ],
    );
  }
}
