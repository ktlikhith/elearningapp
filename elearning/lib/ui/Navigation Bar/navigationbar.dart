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
                print("Pressed");
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.graduationCap),
              onPressed: () {
                print("Pressed");
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.bookOpen),
              onPressed: () {
                print("Pressed");
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.trophy),
              onPressed: () {
                print("Pressed");
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
              // Handle download tap
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
