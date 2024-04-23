import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'dart:io';




class ProfileAPI {
   static Future<Map<String, dynamic>> fetchProfileData(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final response = await http.get(
        Uri.parse(
          '${Constants.baseUrl}/webservice/rest/server.php?moodlewsrestformat=json&wstoken=$token&wsfunction=local_corporate_api_create_profileapi&userid=$userId',
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch profile data');
      }
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }

static Future<void> uploadPhoto(String token) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        const String wsFunction = 'core_user_update_picture';
        final userInfo = await SiteConfigApiService.getUserId(token);
        final userId = userInfo['userid'];
        const int draftItemId = 768027985; // You need to set this value according to your requirement

        final uri = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?moodlewsrestformat=json'
            '&wstoken=$token&wsfunction=$wsFunction&userid=$userId&draftitemid=$draftItemId');

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
}