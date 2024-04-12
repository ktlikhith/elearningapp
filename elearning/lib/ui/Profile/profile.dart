import 'dart:convert';
import 'dart:io'; // Add this import for the File class
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Profile/achivement.dart';
import 'package:elearning/ui/Profile/progressbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Add this import for ImagePicker
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path; // Add this import




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
    const String baseUrl = 'https://lxp-demo2.raptechsolutions.com';
    final userInfo = await SiteConfigApiService.getUserId(token);
    final userId = userInfo['id'];
    try {
      final response = await http.get(Uri.parse('$baseUrl/webservice/rest/server.php?moodlewsrestformat=json&wstoken=$token&wsfunction=local_corporate_api_create_profileapi&userid=$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Extract values from user_info
        List<dynamic> userInfoList = json.decode(data['user_info']);
        if (userInfoList.isNotEmpty) {
          Map<String, dynamic> userInfo = userInfoList[0];
          _studentName = userInfo['studentname'];
          _studentEmail = userInfo['studentemail'];
          // Extract profile picture URL from studentimage
          final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(userInfo['studentimage']);
          if (profilePictureMatch != null) {
            _profilePictureUrl = profilePictureMatch.group(1)!;
          }
        }

        // Extract values from achievements
        List<dynamic> achievementsList = json.decode(data['achievements']);
        if (achievementsList.isNotEmpty) {
          Map<String, dynamic> achievements = achievementsList[0];
          _userPoints = achievements['userpoints'];
          _badgesEarn = achievements['badgesearn'];
          _userLevel = achievements['userlevel'];
        }

        // Extract values from course_progress
        Map<String, dynamic> courseProgress = json.decode(data['course_progress']);
        _completioned = courseProgress['completioned'];
        _inProgress = courseProgress['inprogress'];
        _totalNotStarted = courseProgress['totalnotstarted'];
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
    setState(() {}); // Refresh UI after fetching data
  }
Future<void> _uploadPhoto() async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final String baseUrl = 'https://lxp-demo2.raptechsolutions.com';
      final String wsFunction = 'core_user_update_picture';
      final userInfo = await SiteConfigApiService.getUserId(widget.token);
      final userId = userInfo['id'];
      const int draftItemId = 768027985;

      final uri = Uri.parse('$baseUrl/webservice/rest/server.php?moodlewsrestformat=json'
          '&wstoken=${widget.token}&wsfunction=$wsFunction&userid=$userId&draftitemid=$draftItemId');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(
        'userpicture',
        file.path,
        contentType: MediaType('image', path.extension(file.path).substring(1)),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Photo uploaded successfully.');
        // Optionally, you can update the UI or show a success message
      } else {
        // Handle errors
        print('Failed to upload photo. Error code: ${response.statusCode}');
        // Optionally, you can show an error message to the user
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error uploading photo: $e');
    // Optionally, you can show an error message to the user
  }
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
