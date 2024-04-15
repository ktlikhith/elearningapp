import 'dart:async';
import 'package:flutter/material.dart';

class UpcomingEventsSection extends StatefulWidget {
  const UpcomingEventsSection({Key? key}) : super(key: key);

  @override
  _UpcomingEventsSectionState createState() => _UpcomingEventsSectionState();
}

class _UpcomingEventsSectionState extends State<UpcomingEventsSection> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  int _totalPages = 3; // Total number of pages

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _currentPage++;
      if (_currentPage >= _totalPages) {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 16.0,
              // color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 210, // Adjust height as needed
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is OverscrollNotification) {
                  _currentPage = 0; // Reset current page to first page
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                itemBuilder: (BuildContext context, int index) {
                  // Calculate the current index accounting for looping
                  final currentIndex = index % _totalPages;
                  return _buildEventCard(
                    image: 'https://via.placeholder.com/200',
                    dateTime: 'Time: 8:00 PM',
                    title: 'Event Title $currentIndex',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String image,
    required String dateTime,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 200, // Adjust width as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image of the event
            Container(
              height: 150, // Adjust height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(image), // Image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            // Date and time of the event
            Text(
              dateTime,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4.0),
            // Title of the event
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
