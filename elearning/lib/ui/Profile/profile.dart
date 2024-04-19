import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Profile/achivement.dart';
import 'package:elearning/ui/Profile/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';





class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _profilePictureUrl = '';
  late String _studentName = '';
  late String _studentEmail = '';
  late String _userPoints = '';
  late int _badgesEarn = 0;
  late String _userLevel = '';
  late int _completioned = 0;
  late int _inProgress = 0;
  late double _totalNotStarted = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProfileData(widget.token);
  }

  Future<void> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);

      // Extract values from data and update state
      setState(() {
        final userInfoList = json.decode(data['user_info']);
        if (userInfoList.isNotEmpty) {
          final userInfo = userInfoList[0];
          _studentName = userInfo['studentname'];
          _studentEmail = userInfo['studentemail'];
          final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(userInfo['studentimage']);
          if (profilePictureMatch != null) {
            _profilePictureUrl = profilePictureMatch.group(1)!;
          }
        }

        final achievementsList = json.decode(data['achievements']);
        if (achievementsList.isNotEmpty) {
          final achievements = achievementsList[0];
          _userPoints = achievements['userpoints'];
          _badgesEarn = achievements['badgesearn'];
          _userLevel = achievements['userlevel'];
        }

        final courseProgress = json.decode(data['course_progress']);
        _completioned = courseProgress['completioned'];
        _inProgress = courseProgress['inprogress'];
        _totalNotStarted = courseProgress['totalnotstarted'];
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }
  Future<void> _uploadPhoto() async {
    await ProfileAPI.uploadPhoto(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        color: Colors.grey[200], // Grey background color
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
                      ),
                      IconButton(
                        onPressed: _uploadPhoto,
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _studentName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _studentEmail,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Achievements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildAchievement(_userPoints, 'Points', FontAwesomeIcons.th),
                buildAchievement(_badgesEarn.toString(), 'Badges', FontAwesomeIcons.certificate),
                buildAchievement(_userLevel, 'Level', FontAwesomeIcons.lineChart),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildProgressBar('Task 1', _completioned),
                buildProgressBar('Task 2', _inProgress),
                buildProgressBar('Task 3', _totalNotStarted.toInt()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
