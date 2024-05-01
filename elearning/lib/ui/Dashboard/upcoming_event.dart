// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:elearning/services/live_event.dart';


// class UpcomingEventsSection extends StatefulWidget {
//   final String token;
//   const UpcomingEventsSection({Key? key, required this.token}) : super(key: key);

//   @override
//   _UpcomingEventsSectionState createState() => _UpcomingEventsSectionState();
// }

// class _UpcomingEventsSectionState extends State<UpcomingEventsSection> {
//   late PageController _pageController;
//   late Timer _timer;
//   int _currentPage = 0;
//    late Future<Map<String, dynamic>> _futureData;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//     _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
//       _currentPage++;
//       // You may want to handle resetting the current page here if needed
//     });

//     // Initialize _futureData here
//     _futureData = LiveEventService().fetchLiveEvent(widget.token);
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Upcoming Events',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 15.0),
//           FutureBuilder<Map<String, dynamic>>(
//         future: _futureData, // Use the initialized _futureData here
//             builder: (context, snapshot) {
            
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               // } else if (snapshot.hasError) {
//               //   return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                 return SizedBox(
//                   height: 210,
//                   child: NotificationListener<ScrollNotification>(
//                     onNotification: (notification) {
//                       if (notification is OverscrollNotification) {
//                         // Handle overscroll if needed
//                       }
//                       return false;
//                     },
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final event = snapshot.data![index];
//                         return _buildEventCard(
//                           image: event['image'] ?? '',
//                           dateTime: event['dateTime'] ?? '',
//                           title: event['title'] ?? '',
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               } else {
//                 return Center(child: Text('No events available'));
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventCard({
//     required String image,
//     required String dateTime,
//     required String title,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Container(
//         width: 200,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 150,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: NetworkImage(image),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               dateTime,
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
