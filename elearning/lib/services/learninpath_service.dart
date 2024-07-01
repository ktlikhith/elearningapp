import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class LearningPathApiService {
  static Future<Map<String, dynamic>> fetchLearningPathData(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json&wstoken=$token&'
          'wsfunction=local_corporate_api_create_learningpathapi'
          '&userid=$userId');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch learning path data');
      }
    } catch (e) {
      throw Exception('Error fetching learning path data: $e');
    }
  }
}

class LearningPathDetail {
  final String name;
  final String imageUrl;
  final String description;
  final int progress;
  final String url;
  final List<LearningPathProgress> learningpathProgress;

  LearningPathDetail({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.progress,
    required this.url,
    required this.learningpathProgress,
  });

  factory LearningPathDetail.fromJson(Map<String, dynamic> json, List<dynamic> progressJson) {
    List<LearningPathProgress> learningpathProgress = progressJson.map((i) => LearningPathProgress.fromJson(i)).toList();

    return LearningPathDetail(
      name: json['learningpathname'],
      imageUrl: json['learningpathimage'],
      description: json['discriotion'],
      progress: json['progress'],
      url: json['urllink'],
      learningpathProgress: learningpathProgress,
    );
  }
}

class LearningPathProgress {
  final String name;
  final String description;
  final String imageUrl;
  final int progress;

  LearningPathProgress({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.progress,
  });

  factory LearningPathProgress.fromJson(Map<String, dynamic> json) {
    return LearningPathProgress(
      name: json['coursename'],
      description: json['coursedec'],
      imageUrl: json['courseimg'],
      progress: json['courseprogressbar'],
    );
  }
}
