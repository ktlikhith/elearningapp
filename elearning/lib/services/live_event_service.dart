import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class LiveSessionService {
  Future<List<LiveSession>> fetchLiveSessions(String token) async {
    try {


      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_corporate_api_create_livesessionapi&userid=$userId',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> liveSessionsData = responseData['livesessiondetail'];
        return liveSessionsData.map((sessionData) => LiveSession.fromJson(sessionData)).toList();
      } else {
        throw Exception('Failed to load live sessions');
      }
    } catch (e) {
      throw Exception('Error fetching live sessions: $e');
    }
  }
}

class LiveSession {
  final String activityName;
  final String startTime;
  final String url;
  final String username;
  final String sessionMod;
  final String imgUrl;

  LiveSession({
    required this.activityName,
    required this.startTime,
    required this.url,
    required this.username,
    required this.sessionMod,
    required this.imgUrl,
  });

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    return LiveSession(
      activityName: json['activityname'],
      startTime: json['starttime'],
      url: json['url'],
      username: json['username'],
      sessionMod: json['sessionmod'],
      imgUrl: json['imgurl'],
    );
  }
}
