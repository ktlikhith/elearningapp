import 'dart:convert';

import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class CourseReportApiService {
  Future<List<Course>> getAllCourses(String token) async {
    final userInfo = await SiteConfigApiService.getUserId(token);
    final userId = userInfo['id'];
    final url = '${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json'
        '&wstoken=$token'
        '&wsfunction=local_corporate_api_course_reportapi'
        '&userid=$userId';
    final response = await http.get(Uri.parse(url));

   if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final coursesJsonString = jsonData['allcourses'] as String;
        final List<dynamic> coursesJson = jsonDecode(coursesJsonString);

        // Map the JSON data to Course objects
        final List<Course> courses = coursesJson.map((courseJson) {
          return Course(
            id: courseJson['id'],
            name: courseJson['name'],
            courseImg: courseJson['courseimg'],
            startDate: courseJson['coursestartdate'],
            courseEndDate: courseJson['courseendate'],
            courseDuration:courseJson['course_duration'],
            // Add other fields as needed
          );
        }).toList();

        return courses;
      } catch (e) {
        throw Exception('Error parsing response: $e');
      }
    } else {
      throw Exception('Failed to fetch courses');
    }
  }
}


class Course {
  final String id;
  final String name;
  final String courseImg;
  final String startDate;
  final String courseEndDate;
  final String courseDuration;

  Course({
    required this.id,
    required this.name,
    required this.courseImg,
    required this.startDate,
    required this.courseEndDate,
    required this.courseDuration,
  });

  // factory Course.fromJson(Map<String, dynamic> json) {
  //   return Course(
  //     id: json['id'],
  //     name: json['name'],
  //     courseImg: json['courseimg'],
  //     startDate: json['coursestartdate'],
  //     courseEndDate: json['courseendate'],
  //     courseDuration: json['course_duration']
  //   );
  // }
}
