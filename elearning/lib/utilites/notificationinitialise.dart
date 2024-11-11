

// import 'package:elearning/main.dart';
// import 'package:elearning/services/notification_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationHandler {
//   final Set<int> _displayedNotificationIds = {}; // Set to keep track of displayed notifications

//   Future<void> _showNotification(Notifications notification) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       notification.id,
//       notification.subject,
//       removeHtmlTags(notification.fullMessage),
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   String removeHtmlTags(String htmlString) {
//     RegExp htmlTagRegExp = RegExp(r'<[^>]*>');
//     return htmlString.replaceAll(htmlTagRegExp, '');
//   }

//   Future<void> fetchNotifications(String token) async {
//     print('notifications');
//     final NotificationService _notificationService = NotificationService();
//     try {
//       final List<Notifications> response = await _notificationService.getNotifications(token);

//       for (var notification in response) {
//         // Check if the notification has been displayed already
//         if (!notification.read && !_displayedNotificationIds.contains(notification.id)) {
//           await _showNotification(notification); // Await the notification showing
//           _displayedNotificationIds.add(notification.id); // Mark this notification as displayed
//         }
//       }
//     } catch (e) {
//       print('Error fetching notifications: $e');
//     }
//   }

//   // Optional: Method to reset displayed notifications, if needed
//   void resetDisplayedNotifications() {
//     _displayedNotificationIds.clear();
//   }
// }


import 'package:elearning/main.dart';
import 'package:elearning/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHandler {
  final Set<int> _displayedNotificationIds = {}; // Set to keep track of displayed notifications

  Future<void> init() async {
    // Load previously displayed notification IDs from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList('displayedNotificationIds');
    if (ids != null) {
      _displayedNotificationIds.addAll(ids.map(int.parse)); // Convert to Set<int>
    }
  }

  Future<void> _showNotification(Notifications notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      notification.id,
      notification.subject,
      removeHtmlTags(notification.fullMessage),
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(htmlTagRegExp, '');
  }

  Future<void> fetchNotifications(String token) async {
   

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? MetaToken=prefs.getString('token');
    
    List<String>? ids = prefs.getStringList('displayedNotificationIds');
      if(MetaToken!=null)
    if (ids != null) {
      _displayedNotificationIds.addAll(ids.map(int.parse)); // Convert to Set<int>
    }
    final NotificationService _notificationService = NotificationService();
    try {
      final List<Notifications> response = await _notificationService.getNotifications(token);

      for (var notification in response) {
        // Check if the notification has been displayed already
        if (!notification.read && !_displayedNotificationIds.contains(notification.id)) {
          await _showNotification(notification); // Await the notification showing
          _displayedNotificationIds.add(notification.id); // Mark this notification as displayed
          
          // Store the displayed notification ID in SharedPreferences
          await _storeDisplayedNotificationId(notification.id);
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> _storeDisplayedNotificationId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? ids = prefs.getStringList('displayedNotificationIds') ?? [];
    ids.add(id.toString()); // Convert the id to string and add it to the list
    await prefs.setStringList('displayedNotificationIds', ids);
  }

 
}
