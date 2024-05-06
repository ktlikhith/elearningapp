import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class HomePageService {
  static Future<HomePageData> fetchHomePageData(String token) async {
   final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_corporate_api_create_coursesapi&userid=$userId'
        );

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return HomePageData.fromJson(data);
      } else {
        throw Exception('Failed to load homepage data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class HomePageData {
  final int countActivity;
  final int countSevenDays;
  final int countThirtyDays;
  final List<EventData> evenData;
  final List<CourseData> allCourses;

  HomePageData({
    required this.countActivity,
    required this.countSevenDays,
    required this.countThirtyDays,
    required this.evenData,
    required this.allCourses,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
  final List<EventData> evenDataList = [];
  final List<CourseData> allCoursesList = [];

  if (json['countactivity'] != null &&
      json['countsevendays'] != null &&
      json['countthirtydays'] != null) {
    final countActivity = int.parse(json['countactivity'].toString());
    final countSevenDays = int.parse(json['countsevendays'].toString());
    final countThirtyDays = int.parse(json['countthirtydays'].toString());

    if (json['evendata'] != null) {
      for (var eventData in json['evendata']) {
        if (eventData != null) {
          evenDataList.add(EventData.fromJson(eventData));
        }
      }
    }

    if (json['allcourses'] != null) {
      for (var courseData in json['allcourses']) {
        if (courseData != null) {
          allCoursesList.add(CourseData.fromJson(courseData));
        }
      }
    }

    return HomePageData(
      countActivity: countActivity,
      countSevenDays: countSevenDays,
      countThirtyDays: countThirtyDays,
      evenData: evenDataList,
      allCourses: allCoursesList,
    );
  } else {
    throw Exception('Invalid data received from API');
  }
}

}

class EventData {
  final String id;
  final String name;
  final String eventType;
  final String dueDate;
  final String timeDuration;
  final String url;

  EventData({
    required this.id,
    required this.name,
    required this.eventType,
    required this.dueDate,
    required this.timeDuration,
    required this.url,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      eventType: json['eventtype'] ?? '',
      dueDate: json['duedate '] ?? '',
      timeDuration: json['timeduration'] ?? '',
      url: json['url'] ??'',
    );
  }
}

class CourseData {
  final String id;
  final String name;
  final String courseImg;
  final int courseProgress;
  final String courseDescription;
  final String courseStartDate;
  final String courseEndDate;
  final String courseVideoUrl;
  final String courseDuration;

  CourseData({
    required this.id,
    required this.name,
    required this.courseImg,
    required this.courseProgress,
    required this.courseDescription,
    required this.courseStartDate,
    required this.courseEndDate,
    required this.courseVideoUrl,
    required this.courseDuration,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
  return CourseData(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    courseImg: json['courseimg'] ?? '',
    courseProgress: json['courseprogress'] ?? 0,
    courseDescription: json['coursedescription'] ?? '',
    courseStartDate: json['coursestartdate'] ?? '',
    courseEndDate: json['courseendate'] ?? '',
    courseVideoUrl: json['course_videourl'] ?? '',
    courseDuration: json['course_duration'] ?? '',
  );
}
 String getImageUrlWithToken(String token) {
    return '$courseImg?token=$token';
  }

}
