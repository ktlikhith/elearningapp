

// import 'dart:convert';

// import 'package:elearning/services/auth.dart';
// import 'package:elearning/services/notification_service.dart';
// import 'package:elearning/ui/Webview/testweb.dart';
// import 'package:elearning/ui/Webview/webview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shimmer/shimmer.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationScreen extends StatefulWidget {
//   final String token;

//   const NotificationScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final NotificationService _notificationService = NotificationService();
//   late List<Notifications> _notifications = [];
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//    // _initializeNotifications();

//   }

//   // Future<void> _initializeNotifications() async {
//   //   const AndroidInitializationSettings initializationSettingsAndroid =
//   //       AndroidInitializationSettings('app_icon'); // Ensure you have an app_icon in your drawable resources

//   //   final InitializationSettings initializationSettings = InitializationSettings(
//   //     android: initializationSettingsAndroid,
//   //   );

//   //   await flutterLocalNotificationsPlugin.initialize(
//   //     initializationSettings,
//   //   );
//   // }

//   Future<void> _fetchNotifications(String token) async {
//     try {
//       final List<Notifications> response = await _notificationService.getNotifications(token);
//       setState(() {
//         _notifications = response;
//       });

//       for (var notification in response) {
//         if (!notification.read) {
//           _showNotification(notification);
//         }
//       }
//     } catch (e) {
//       print('Error fetching notifications: $e');
//     }
//   }
  
//    Stream<List<Notifications>> getnoti(String token) async* {
//     try {
//     final List<Notifications> response = await _notificationService.getNotifications(token);

      
// //  for (var notification in response) {
// //         if (!notification.read) {
// //           _showNotification(notification);
// //         }
// //       }
      
//         yield response;
    
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Failed to load user reward points');
//     }

//   }


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

// // Future<void> _showNotification(Notifications notification) async {
// //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //       AndroidNotificationDetails(
// //     'your_channel_id',
// //     'your_channel_name',
// //     channelDescription: 'your_channel_description',
// //     importance: Importance.max,
// //     priority: Priority.high,
// //     showWhen: false,
// //   );
  
// //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
// //     android: androidPlatformChannelSpecifics,
// //   );

// //   // Optionally pass a simple payload if needed
// //   await flutterLocalNotificationsPlugin.show(
// //     notification.id,
// //     notification.subject,
// //     removeHtmlTags(notification.fullMessage), // You can choose to omit this
// //     platformChannelSpecifics,
// //     payload: jsonEncode({'type': 'notification'}), // Simple payload if needed
// //   );
// // }




//   Future<void> _markNotificationAsRead(int notificationId) async {
//     try {
//       final url = '${Constants.baseUrl}/webservice/rest/server.php?'
//           'moodlewsrestformat=json'
//           '&wstoken=${widget.token}'
//           '&wsfunction=core_message_mark_notification_read'
//           '&notificationid=$notificationId';

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           final index = _notifications.indexWhere((n) => n.id == notificationId);
//           if (index != -1) {
//             _notifications[index].read = true;
//           }
//         });
//       } else {
//         print('Failed to mark notification as read');
//       }
//     } catch (e) {
//       print('Error marking notification as read: $e');
//     }
//   }

//   Widget _buildShimmerList() {
//     return ListView.builder(
//       itemCount: 5,
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
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: StreamBuilder<List<Notifications>>(
//         stream: getnoti(widget.token),
//         builder: (context, snapshot) {
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return  _buildShimmerList();

//           }
        
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error loading user info'));
//               }
            
//              if(snapshot==null){
//             return Center(child: Text('You dont have any Notifications.'));
//             }
//             else if(snapshot.hasData){
//               _notifications=snapshot.data!;
//               List<dynamic> unreadNotifications = _notifications.where((notification) => !notification.read).toList();
//           return Container(
            
//             padding: EdgeInsets.all(8.0),
//             child: TabBar(
//               isScrollable: true,
//               labelColor: Theme.of(context).cardColor, // Active label color
//               unselectedLabelColor: Colors.black, // Inactive label color
//               indicatorColor:Theme.of(context).cardColor, // Active line color
//               indicatorWeight: 4.0, 
//               // Thickness of the active line
//               tabs: [
//                 Tab(text: "  All  ",
//                 child: ListView.builder(
//                         itemCount: _notifications.length,
//                         itemBuilder: (context, index) {
//                           final notification = _notifications[index];
//                           return Container(
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.white,
//                                   spreadRadius: 2,
//                                   blurRadius: 5,
//                                   offset: Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               title: Text(
//                                 notification.subject,
//                                 style: TextStyle(
//                                   fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
//                                   color: notification.read ? Colors.black :Theme.of(context).cardColor,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(notification.timeCreatedPretty),
//                                   TextButton(
//                                     onPressed: () async {
//                                       await _markNotificationAsRead(notification.id);
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => NotificationDetailsScreen(
//                                             token: widget.token,
//                                             notification: notification,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     style: ButtonStyle(
//                                       overlayColor: MaterialStateProperty.all(Colors.transparent),
//                                     ),
//                                     child: Text(
//                                       'View Full Notification',
//                                       style: TextStyle(color: Theme.of(context).primaryColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),), // Tab for first screen
//                 Tab(text: "Unread",
//                 child: ListView.builder(
//                         itemCount: unreadNotifications.length,
//                         itemBuilder: (context, index) {
//                           final notification = unreadNotifications[index];
//                           return Container(
//                             margin: EdgeInsets.symmetric(vertical: 8.0),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.white,
//                                   spreadRadius: 2,
//                                   blurRadius: 5,
//                                   offset: Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: ListTile(
//                               title: Text(
//                                 notification.subject,
//                                 style: TextStyle(
//                                   fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
//                                   color: notification.read ? Colors.black :Theme.of(context).cardColor,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(notification.timeCreatedPretty),
//                                   TextButton(
//                                     onPressed: () async {
//                                       await _markNotificationAsRead(notification.id);
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => NotificationDetailsScreen(
//                                             token: widget.token,
//                                             notification: notification,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     style: ButtonStyle(
//                                       overlayColor: MaterialStateProperty.all(Colors.transparent),
//                                     ),
//                                     child: Text(
//                                       'View Full Notification',
//                                       style: TextStyle(color: Theme.of(context).primaryColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),), // Tab for second screen
                 
//               ]               
//             )
              
//           );
          
//           }
//            else return Container(child: Center(child: Text('somethinng went wrong'),),);
         
//         }
        
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
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
//                   color: Theme.of(context).cardColor,
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
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (notification.contextUrl != null && notification.contextUrl.isNotEmpty) {
            //         String moduleUrl = notification.contextUrl;
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => WebViewPage('Insights', moduleUrl, token),
            //           ),
            //         );
            //       }
            //     },
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).secondaryHeaderColor),
            //     ),
            //     child: Text('View Insight', style: TextStyle(color: Colors.white)),
            //   ),
            // ),
//           ],
//         ),
//       ),
//     );
//   }

  
// }

//   String removeHtmlTags(String htmlString) {
//     RegExp htmlTagRegExp = RegExp(r'<[^>]*>');
//     return htmlString.replaceAll(htmlTagRegExp, '');
//   }


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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications(widget.token);
  }

  Future<void> _fetchNotifications(String token) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<Notifications> response =
          await _notificationService.getNotifications(token);
      setState(() {
        _notifications = response;
      });

      // for (var notification in response) {
      //   if (!notification.read) {
      //     _showNotification(notification);
      //   }
      // }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _markNotificationAsRead(int notificationId) async {
    try {
      final url =
          '${Constants.baseUrl}/webservice/rest/server.php?moodlewsrestformat=json&wstoken=${widget.token}&wsfunction=core_message_mark_notification_read&notificationid=$notificationId';

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
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                width: double.infinity,
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                color: Colors.grey[300],
                height: 16,
                width: double.infinity,
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).cardColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).cardColor,
              indicatorWeight: 4.0,
              tabs: [
                Tab(text: "All Notifications"),
                Tab(text: "Unread Notifications"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: All Notifications
                  _isLoading
                      ? _buildShimmerList()
                      : _buildNotificationList(_notifications),
                  // Tab 2: Unread Notifications
                  _isLoading
                      ? _buildShimmerList()
                      : _buildNotificationList(
                          _notifications.where((n) => !n.read).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<Notifications> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Text('No notifications found'),
      );
    }
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(Notifications notification) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).cardColor),
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
        title: Text(
          notification.subject,
          style: TextStyle(
            fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
            color: notification.read ? Colors.black : Theme.of(context).cardColor,
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
              child: Text(
                'View Full Notification',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationDetailsScreen extends StatelessWidget {
  final String token;
  final Notifications notification;

  const NotificationDetailsScreen({
    Key? key,
    required this.token,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Notification Details'),
         leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(removeHtmlTags(notification.fullMessage)),
                           ElevatedButton(
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
