import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class ReportService {
  
  Future<Report> fetchReport(String token) async {
     final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final apiUrl = Uri.parse('${Constants.baseUrl}/webservice/rest/server.php?'
      'moodlewsrestformat=json&wstoken=$token&wsfunction=local_corporate_api_user_reportapi&userid=$userId');
      final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Report.fromJson(jsonData);
    } else {
      throw Exception('Failed to load report');
    }
  }
}

class Report {
  final String id;
  final String studentName;
  final String studentImage;
  final double averageGrade;
  final int totalNoActivity;
  final int completedActivity;

  Report({
    required this.id,
    required this.studentName,
    required this.studentImage,
    required this.averageGrade,
    required this.totalNoActivity,
    required this.completedActivity,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? 0,
      studentName: json['studentname'] ,
      studentImage: json['studentimage'] ,
      averageGrade: json['avragegrade'].toDouble() ,
      totalNoActivity: json['totalnoactivity'] ,
      completedActivity: json['completedactivity'] ,
    );
  }
}
