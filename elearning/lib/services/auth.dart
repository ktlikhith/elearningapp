import 'dart:convert';
import 'package:elearning/services/profile_service.dart';
import 'package:http/http.dart' as http;




class Constants {
  static const String baseUrl = 'https://lxp-demo2.raptechsolutions.com';
}


class AuthService {

  static Future<Map<String, dynamic>> login(String username, String password, String service) async {
    final url = Uri.parse('${Constants.baseUrl}/login/token.php?username=$username&password=$password&service=$service');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'token': responseData['token'],
        //'privateToken': responseData['privatetoken'],
      };
      
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}

class SiteConfigApiService {
  static Future<Map<String, dynamic>> getUserId(String token) async {
    final url = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?wsfunction=core_webservice_get_site_info&moodlewsrestformat=json&wstoken=$token&serviceshortnames[0]=moodle_mobile_app');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> functions = responseData['functions'];
      final List<String> functionNames = functions.map((function) => function['name'].toString()).toList();
      
      return {
        'id': responseData['userid'],
        'fullname': responseData['fullname'],
        'username': responseData['username'],
        'firstname': responseData['firstname'],
        'userpictureurl': responseData['userpictureurl'],
        'siteurl': responseData['siteurl'],
        'functions': functionNames,
      };
    } else {
      throw Exception('Failed to fetch user ID');
    }
  }
}


class DueApiService {
  static Future<Map<String, dynamic>> getDueInfo(String token, int userId) async {
    try {
      final dueUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json&wstoken=$token&'
          'wsfunction=local_corporate_api_create_coursesapi&userid=$userId');
  
      final response = await http.get(dueUrl);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return{
          'countactivity': responseData['countactivity'],
          'countsevendays': responseData['countsevendays'],
          'countthirtydays': responseData['countthirtydays'],
          //'functions': functionNames,
        };
      } else {
        throw Exception('Failed to fetch due information');
      }
    } catch (e) {
      print('Error fetching due information: $e');
      rethrow;
    }
  }
}


class TanentLogo {
  static Future<Map<String, dynamic>> fetchTenantUserData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
     
        final response = await http.get(Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?moodlewsrestformat=json&wstoken=$token&wsfunction=tenent_users_data&tenant[0][username]=marryjosheph@gmail.com'));

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          return responseData;
        } 
       else {
        throw Exception('No user information found');
      }
    } catch (e) {
      throw Exception('Error fetching tenant user data: $e');
    }
  }
  // Add other service methods as needed
}


class NotificationCount {
  static Future<int> getUnreadNotificationCount(String token) async {
    try {
       final userInfo =  await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final url = '${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json'
          '&wstoken=$token'
          '&wsfunction=message_popup_get_unread_popup_notification_count'
          '&useridto=$userId';

      final response = await http.get(Uri.parse(url));
     if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return int.parse(jsonResponse.toString());
      } else {
        throw Exception('Failed to load unread notification count');
      }
    } catch (e) {
      print('Error fetching notification count: $e');
      throw Exception('Failed to load unread notification count');
    }
  }
}





// class CourseReportApiService {
  

//    Future<List<Course>> getAllCourses(String token) async {
    
//       final userInfo =  await SiteConfigApiService.getUserId(token);
//       final userId = userInfo['id'];
//       final url = '${Constants.baseUrl}/webservice/rest/server.php?'
//           'moodlewsrestformat=json'
//           '&wstoken=$token'
//           '&wsfunction=local_corporate_api_course_reportapi'
//           '&userid=$userId';
//       final response = await http.get(Uri.parse(url));
      
//       if (response.statusCode == 200) {
//       try {
//         final jsonData = jsonDecode(response.body);
        
//         // Check if the jsonData is a String, then attempt to parse it
//         if (jsonData is String) {
//           final coursesJson = jsonDecode(jsonData) as List<dynamic>;
//           return coursesJson.map((courseJson) => Course.fromJson(courseJson)).toList();
//         }
//         // If jsonData is not a String, assume it's already a List<dynamic>
//         else if (jsonData is List<dynamic>) {
//           return jsonData.map((courseJson) => Course.fromJson(courseJson)).toList();
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } catch (e) {
//         throw Exception('Error parsing response: $e');
//       }
//     } else {
//       // If response status code is not 200, throw an error
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

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['id'],
//       name: json['name'],
//       courseImg: json['courseimg'],
//       startDate: json['coursestartdate'],
//       courseEndDate: json['courseendate'],
//       courseDuration: json['course_duration']
//     );
//   }
// }

