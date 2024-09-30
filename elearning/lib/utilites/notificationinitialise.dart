  import 'package:elearning/main.dart';
import 'package:elearning/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Ensure you have an app_icon in your drawable resources

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
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
    Future<void> _fetchNotifications(String token) async {
        final NotificationService _notificationService = NotificationService();
    try {
      final List<Notifications> response = await _notificationService.getNotifications(token);
     

      for (var notification in response) {
        if (!notification.read) {
          _showNotification(notification);
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }