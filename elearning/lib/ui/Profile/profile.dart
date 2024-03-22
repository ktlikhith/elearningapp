import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Profile/achivement.dart';
import 'package:elearning/ui/Profile/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ProfilePage();
    
  }
}

class ProfilePage extends StatelessWidget {
  // Mock profile data
  final Map<String, dynamic> profileData = {
    'profilePicture': 'https://via.placeholder.com/150',
    'name': 'John Doe',
    'emails': ['john.doe@example.com', 'john.doe@gmail.com']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(RouterManger.homescreen);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Grey background color
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(profileData['profilePicture']),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profileData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: profileData['emails']
                        .map<Widget>((email) => Text(
                              email,
                              style: TextStyle(fontSize: 16),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Achivements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildAchievement('100', 'Points', FontAwesomeIcons.th),
                buildAchievement('50', 'Badges', FontAwesomeIcons.certificate),
                buildAchievement(
                    '200', 'Level', FontAwesomeIcons.lineChart),
              ],
            ),

            SizedBox(height: 20),
            Text(
              'Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildProgressBar('Task 1', 25),
                buildProgressBar('Task 2', 75),
                buildProgressBar('Task 3', 25),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
}
