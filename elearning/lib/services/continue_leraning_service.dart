import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class ContinueService {
  Future<List<Course>> fetchCourses(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_corporate_api_create_coursesapi&userid=$userId',
      );
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        //print(responseData);
        final List<dynamic> coursesData = responseData['allcourses'];
        return coursesData.map((courseData) => Course.fromJson(courseData)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }
}

class Course {
  final String id;
  final String name;
  final String courseImg;
  final int courseProgress;
  final String? courseDescription;
  final String courseStartDate;
  final String courseEndDate;
  final String courseVideoUrl;
  final String courseDuration;

  Course({
    required this.id,
    required this.name,
    required this.courseImg,
    required this.courseProgress,
    this.courseDescription,
    required this.courseStartDate,
    required this.courseEndDate,
    required this.courseVideoUrl,
    required this.courseDuration,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      courseImg: json['courseimg'],
      courseProgress: json['courseprogress'] ?? 0,
      courseDescription: json['coursedescription'],
      courseStartDate: json['coursestartdate'],
      courseEndDate: json['courseendate'],
      courseVideoUrl: json['course_videourl'] ?? '',
      courseDuration: json['course_duration'] ?? '',
    );
  }

  String getImageUrlWithToken(String token) {
    return '$courseImg?token=$token';
  }
}
