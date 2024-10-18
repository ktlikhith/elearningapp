import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<List<Notifications>> getNotifications(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];
      final url = '${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json'
          '&wstoken=$token'
          '&wsfunction=message_popup_get_popup_notifications'
          '&useridto=$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['notifications'];
        return jsonList.map((json) => Notifications.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw e;
    }
  }
  

}

class Notifications {
  final int id;
  final int userIdFrom;
  final int userIdTo;
  final String subject;
  final String shortenedSubject;
  final String text;
  final String fullMessage;
  final int fullMessageFormat;
  final String fullMessageHtml;
  final String smallMessage;
  final String contextUrl;
  final String contextUrlName;
  final int timeCreated;
  final String timeCreatedPretty;
  final int? timeRead; // Made this nullable to handle possible null values
        bool read;
  final bool deleted;
  final String iconUrl;
  final String component;
  final String eventType;
  

  Notifications({
    required this.id,
    required this.userIdFrom,
    required this.userIdTo,
    required this.subject,
    required this.shortenedSubject,
    required this.text,
    required this.fullMessage,
    required this.fullMessageFormat,
    required this.fullMessageHtml,
    required this.smallMessage,
    required this.contextUrl,
    required this.contextUrlName,
    required this.timeCreated,
    required this.timeCreatedPretty,
    required this.timeRead,
    required this.read,
    required this.deleted,
    required this.iconUrl,
    required this.component,
    required this.eventType,
    
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      userIdFrom: json['useridfrom'],
      userIdTo: json['useridto'],
      subject: json['subject'],
      shortenedSubject: json['shortenedsubject'],
      text: json['text'],
      fullMessage: json['fullmessage'],
      fullMessageFormat: json['fullmessageformat'],
      fullMessageHtml: json['fullmessagehtml'],
      smallMessage: json['smallmessage'],
      contextUrl: json['contexturl']??"Null",
      contextUrlName: json['contexturlname'],
      timeCreated: json['timecreated'],
      timeCreatedPretty: json['timecreatedpretty'],
      timeRead: json['timeread'],
     
      deleted: json['deleted'],
      iconUrl: json['iconurl'],
      component: json['component'],
      eventType: json['eventtype'],
      read: json['read'] ?? false,
    );
  }
   String getImageUrlWithToken(String token) {
    print(iconUrl);
    return '$iconUrl';
}
}


