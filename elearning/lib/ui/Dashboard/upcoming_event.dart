import 'dart:async';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingEventsSection extends StatefulWidget {
  final String token;

  const UpcomingEventsSection({Key? key, required this.token}) : super(key: key);

  @override
  _UpcomingEventsSectionState createState() => _UpcomingEventsSectionState();
}

class _UpcomingEventsSectionState extends State<UpcomingEventsSection> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  Future<List<EventData>>? _futureEventData;
  String img = 'https://lxp-demo2.raptechsolutions.com/theme/remui/pix/demo-img.png';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      final eventData = await _futureEventData;
      setState(() {
        if (eventData != null && eventData.isNotEmpty) {
          _currentPage = (_currentPage + 1) % eventData.length;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      });
    });

    // Initialize _futureEventData here
    _futureEventData = HomePageService.fetchHomePageData(widget.token)
        .then((homePageData) => homePageData.evenData);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          FutureBuilder<List<EventData>>(
            future: _futureEventData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect(context); // Updated to pass context
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return SizedBox(
                  height: 210,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is OverscrollNotification) {
                        // Handle overscroll if needed
                      }
                      return false;
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = snapshot.data![index];
                        return _buildEventCard(
                          image: img,
                          dateTime: event.dueDate,
                          title: event.name,
                          context: context,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Center(child: Text('No events available'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8; // Adjust as needed

    return SizedBox(
      height: 210,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: cardWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventCard({
    required String image,
    required String dateTime,
    required String title,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(RouterManger.livesession, arguments: widget.token);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Text(
                    dateTime,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
