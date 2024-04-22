import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class LiveEventService {
  

  Future<Map<String, dynamic>> fetchLiveEvent(String token) async {
     final userInfo = await SiteConfigApiService.getUserId(token);
    final userId = userInfo['id'];
    final url = '${Constants.baseUrl}?moodlewsrestformat=json'
        '&wstoken=$token'
        '&wsfunction=local_corporate_api_create_livesessionapi'
        '&userid=$userId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data is Map<String, dynamic>) {
        // Check if the response contains the necessary fields
        if (data.containsKey('title') &&
            data.containsKey('speaker_name') &&
            data.containsKey('event_type') &&
            data.containsKey('address') &&
            data.containsKey('description') &&
            data.containsKey('image')) {
          return {
            'title': data['title'] ,
            'speakerName': data['speaker_name'] ,
            'eventType': data['event_type'],
            'address': data['address'] ,
            'description': data['description'] ,
            'image': data['image'],
          };
        } else {
          return {'error': 'Incomplete data'};
        }
      } else {
        return {'error': 'Invalid data format'};
      }
    } else {
      return {'error': 'Failed to fetch data'};
    }
  }
}
