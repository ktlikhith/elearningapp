// import 'dart:convert';

// import 'package:elearning/services/auth.dart';
// import 'package:http/http.dart' as http;

// class CourseReportApiService {
//   Future<List<Course>> getAllCourses(String token) async {
//     final userInfo = await SiteConfigApiService.getUserId(token);
//     final userId = userInfo['id'];
//     final url = '${Constants.baseUrl}/webservice/rest/server.php?'
//         'moodlewsrestformat=json'
//         '&wstoken=$token'
//         '&wsfunction=local_corporate_api_course_reportapi'
//         '&userid=$userId';
//     final response = await http.get(Uri.parse(url));

//    if (response.statusCode == 200) {
//       try {
//         final jsonData = jsonDecode(response.body);
//         final coursesJsonString = jsonData['allcourses'] as String;
//         final List<dynamic> coursesJson = jsonDecode(coursesJsonString);

//         // Map the JSON data to Course objects
//         final List<Course> courses = coursesJson.map((courseJson) {
//           return Course(
//             id: courseJson['id'],
//             name: courseJson['name'],
//             courseImg: courseJson['courseimg'],
//             startDate: courseJson['coursestartdate'],
//             courseEndDate: courseJson['courseendate'],
//             courseDuration:courseJson['course_duration'],
//             // Add other fields as needed
//           );
//         }).toList();

//         return courses;
//       } catch (e) {
//         throw Exception('Error parsing response: $e');
//       }
//     } else {
//       throw Exception('Failed to fetch courses');
//     }
//   }
// }


// class Course {
//   final String id;
//   final String name;
//   final String courseImg;
//   final String startDate;
//   final String courseEndDate;
//   final String courseDuration;

//   Course({
//     required this.id,
//     required this.name,
//     required this.courseImg,
//     required this.startDate,
//     required this.courseEndDate,
//     required this.courseDuration,
//   });

// }
import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class CourseReportApiService {
  Future<List<Course>> fetchCourses(String token) async {
    final userInfo = await SiteConfigApiService.getUserId(token);
    final userId = userInfo['id'];
    final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_corporate_api_create_coursesapi&userid=$userId');
    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> coursesData = responseData['allcourses'];
        
        return coursesData.map((courseData) => Course.fromJson(courseData)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  Future<String> getCourseImageWith_token_id(String token, String courseId) async {
    try {
      List<Course> courses = await fetchCourses(token);
      for (Course course in courses) {
        if (course.id == courseId) {
          return course.getImageUrlWithToken(token);
        }
      }
      throw Exception('Course not found');
    } catch (e) {
      throw Exception('Error retrieving course image: $e');
    }
  }
   Future<String> getCourseDescriptionWith_token_id(String token, String courseId) async {
    try {
      List<Course> courses = await fetchCourses(token);
      for (Course course in courses) {
        if (course.id == courseId) {
          return course.getcourseDescriptionWithToken(token);
        }
      }
      throw Exception('Course not found');
    } catch (e) {
      throw Exception('Error retrieving course image: $e');
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

  String getCourseIDWithToken(String token) {
    return '$id';
  }

  String getcoursenameWithToken(String token) {
    return '$name';
  }

  String getcourseProgressWithToken(String token) {
    return '$courseProgress';
  }

  String getcourseDescriptionWithToken(String token) {
    return '$courseDescription';
  }

  String getcourseStartDateWithToken(String token) {
    return '$courseStartDate';
  }

  String getcourseEndDateWithToken(String token) {
    return '$courseEndDate';
  }

  String getcourseVideoUrlWithToken(String token) {
    return '$courseVideoUrl';
  }

  String getcourseDurationWithToken(String token) {
    return '$courseDuration';
  }
}
