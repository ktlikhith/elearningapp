// import 'package:elearning/services/auth.dart';
// import 'package:elearning/services/notification_service.dart';
// import 'package:elearning/ui/Webview/testweb.dart';
// import 'package:elearning/ui/Webview/webview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:shimmer/shimmer.dart'; // Import the shimmer package

// class NotificationScreen extends StatefulWidget {
//   final String token;

//   const NotificationScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final NotificationService _notificationService = NotificationService();
//   late List<Notifications> _notifications = []; // Initialize the notifications list

//   @override
//   void initState() {
//     super.initState();
//     _fetchNotifications(widget.token); // Fetch notifications when the screen initializes
//   }

//   Future<void> _fetchNotifications(String token) async {
//     try {
//       final List<Notifications> response = await _notificationService.getNotifications(token);
//       setState(() {
//         _notifications = response; // Update the list of notifications in the state
//       });
//     } catch (e) {
//       print('Error fetching notifications: $e');
//     }
//   }

//   Future<void> _markNotificationAsRead(int notificationId) async {
//     try {
//       // Construct API URL
//       final url = '${Constants.baseUrl}/webservice/rest/server.php?'
//           'moodlewsrestformat=json'
//           '&wstoken=${widget.token}'
//           '&wsfunction=core_message_mark_notification_read'
//           '&notificationid=$notificationId';

//       // Call API
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           // Find the notification in the list and update its read status
//           final index = _notifications.indexWhere((n) => n.id == notificationId);
//           if (index != -1) {
//             _notifications[index].read = true;
//           }
//         });
//         //print('Notification marked as read successfully');
//       } else {
//         print('Failed to mark notification as read');
//       }
//     } catch (e) {
//       print('Error marking notification as read: $e');
//     }
//   }

//   Widget _buildShimmerList() {
//     return ListView.builder(
//       itemCount: 5, // Adjust the number of shimmer placeholders as needed
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: 8.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               title: Container(
//                 color: Colors.grey[300],
//                 height: 20,
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     color: Colors.grey[300],
//                     height: 16,
//                   ),
//                   SizedBox(height: 4),
//                   Container(
//                     color: Colors.grey[300],
//                     height: 16,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Container(
//         padding: EdgeInsets.all(8.0),
//         child: _notifications != null
//             ? _notifications.isEmpty
//                 ? Center(child: Text('No notifications to read'))
//                 : ListView.builder(
//                     itemCount: _notifications.length,
//                     itemBuilder: (context, index) {
//                       final notification = _notifications[index];
//                       return Container(
//                         margin: EdgeInsets.symmetric(vertical: 8.0),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey), // Example border style
//                           borderRadius: BorderRadius.circular(10), // Example border radius
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white,
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: ListTile(
//                           title: Text(
//                             notification.subject,
//                             style: TextStyle(
//                               fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
//                               color: notification.read ? Colors.black : Colors.blue,
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(notification.timeCreatedPretty),
//                               TextButton(
//                                 onPressed: () async {
//                                   await _markNotificationAsRead(notification.id);
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => NotificationDetailsScreen(
//                                         token: widget.token,
//                                         notification: notification,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 style: ButtonStyle(
//                                   overlayColor: MaterialStateProperty.all(Colors.transparent),
//                                 ),
//                                 child: Text(
//                                   'View Full Notification',
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   )
//             : _buildShimmerList(), // Show shimmer skeleton while loading
//       ),
//     );
//   }
// }

// class NotificationDetailsScreen extends StatelessWidget {
//   final String token;
//   final Notifications notification;

//   const NotificationDetailsScreen({Key? key, required this.token, required this.notification}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification Details'),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 SvgPicture.network(
//                   notification.getImageUrlWithToken(token),
//                   placeholderBuilder: (context) => CircularProgressIndicator(),
//                   width: 40,
//                   height: 40,
//                   color: Colors.blue, // Set the color of the SVG image
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     notification.subject,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               notification.timeCreatedPretty,
//               style: TextStyle(
//                 color: const Color.fromARGB(255, 61, 60, 60),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               removeHtmlTags(notification.fullMessage),
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 if (notification.contextUrl != null && notification.contextUrl.isNotEmpty) {
//                   String moduleUrl = notification.contextUrl;
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WebViewPage('Insights', moduleUrl,token),
//                     ),
//                   );
//                 }
//               },
//               style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).secondaryHeaderColor),
              
//             ),
//               child: Text('View Insight',style: TextStyle(color: Colors.white)),
//             ),
//           ),
//           ],
//         ),
//       ),
//     );
//   }

//   String removeHtmlTags(String htmlString) {
//     RegExp htmlTagRegExp = RegExp(r'<[^>]*>'); // Regular expression to match HTML tags
//     return htmlString.replaceAll(htmlTagRegExp, ''); // Remove HTML tags using replaceAll method
//   }
// }

import 'dart:convert';

import 'package:elearning/services/auth.dart';
import 'package:elearning/services/notification_service.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:elearning/ui/Webview/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  final String token;

  const NotificationScreen({Key? key, required this.token}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  late List<Notifications> _notifications = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
   // _initializeNotifications();

  }

  // Future<void> _initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon'); // Ensure you have an app_icon in your drawable resources

  //   final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //   );
  // }

  Future<void> _fetchNotifications(String token) async {
    try {
      final List<Notifications> response = await _notificationService.getNotifications(token);
      setState(() {
        _notifications = response;
      });

      for (var notification in response) {
        if (!notification.read) {
          _showNotification(notification);
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }
  
   Stream<List<Notifications>> getnoti(String token) async* {
    try {
    final List<Notifications> response = await _notificationService.getNotifications(token);

      
//  for (var notification in response) {
//         if (!notification.read) {
//           _showNotification(notification);
//         }
//       }
      
        yield response;
    
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load user reward points');
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

// Future<void> _showNotification(Notifications notification) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     channelDescription: 'your_channel_description',
//     importance: Importance.max,
//     priority: Priority.high,
//     showWhen: false,
//   );
  
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );

//   // Optionally pass a simple payload if needed
//   await flutterLocalNotificationsPlugin.show(
//     notification.id,
//     notification.subject,
//     removeHtmlTags(notification.fullMessage), // You can choose to omit this
//     platformChannelSpecifics,
//     payload: jsonEncode({'type': 'notification'}), // Simple payload if needed
//   );
// }




  Future<void> _markNotificationAsRead(int notificationId) async {
    try {
      final url = '${Constants.baseUrl}/webservice/rest/server.php?'
          'moodlewsrestformat=json'
          '&wstoken=${widget.token}'
          '&wsfunction=core_message_mark_notification_read'
          '&notificationid=$notificationId';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          final index = _notifications.indexWhere((n) => n.id == notificationId);
          if (index != -1) {
            _notifications[index].read = true;
          }
        });
      } else {
        print('Failed to mark notification as read');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Container(
                color: Colors.grey[300],
                height: 20,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[300],
                    height: 16,
                  ),
                  SizedBox(height: 4),
                  Container(
                    color: Colors.grey[300],
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<Notifications>>(
        stream: getnoti(widget.token),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return  _buildShimmerList();

          }
        
              if (snapshot.hasError) {
                return Center(child: Text('Error loading user info'));
              }
            
             if(snapshot==null){
            return Center(child: Text('You dont have any Notifications.'));
            }
            else if(snapshot.hasData){
              _notifications=snapshot.data!;
          return Container(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                notification.subject,
                                style: TextStyle(
                                  fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
                                  color: notification.read ? Colors.black : Colors.blue,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.timeCreatedPretty),
                                  TextButton(
                                    onPressed: () async {
                                      await _markNotificationAsRead(notification.id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotificationDetailsScreen(
                                            token: widget.token,
                                            notification: notification,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    ),
                                    child: Text(
                                      'View Full Notification',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
              
          );
          
          }
           else return Container(child: Center(child: Text('somethinng went wrong'),),);
         
        }
        
      ),
    );
  }

}

class NotificationDetailsScreen extends StatelessWidget {
  final String token;
  final Notifications notification;

  const NotificationDetailsScreen({Key? key, required this.token, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.network(
                  notification.getImageUrlWithToken(token),
                  placeholderBuilder: (context) => CircularProgressIndicator(),
                  width: 40,
                  height: 40,
                  color: Theme.of(context).cardColor,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification.subject,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              notification.timeCreatedPretty,
              style: TextStyle(
                color: const Color.fromARGB(255, 61, 60, 60),
              ),
            ),
            SizedBox(height: 8),
            Text(
              removeHtmlTags(notification.fullMessage),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (notification.contextUrl != null && notification.contextUrl.isNotEmpty) {
                    String moduleUrl = notification.contextUrl;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage('Insights', moduleUrl, token),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).secondaryHeaderColor),
                ),
                child: Text('View Insight', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}

  String removeHtmlTags(String htmlString) {
    RegExp htmlTagRegExp = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(htmlTagRegExp, '');
  }
