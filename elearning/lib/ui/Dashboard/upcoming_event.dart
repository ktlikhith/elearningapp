import 'dart:async';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<String> svgAssets = [
    'assets/liveeventsvg/event2.svg',
    'assets/liveeventsvg/event3.svg',
    'assets/liveeventsvg/event4.svg',
    'assets/liveeventsvg/event8.svg',
    'assets/liveeventsvg/event9.svg',
    'assets/liveeventsvg/event10.svg',
    'assets/liveeventsvg/event11.svg',
    'assets/liveeventsvg/event12.svg',
    'assets/liveeventsvg/event13.svg',
    'assets/liveeventsvg/event14.svg',
    'assets/liveeventsvg/event15.svg',
  ]; // Add your SVG asset paths here

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) async {
      final eventData = await _futureEventData;
      if (eventData != null && eventData.isNotEmpty) {
        setState(() {
          _currentPage = (_currentPage + 1) % eventData.length;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        });
      }
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
    return FutureBuilder<List<EventData>>(
      future: _futureEventData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect(context);
        } else if (snapshot.hasError) {
          return Center(
            
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
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
                SizedBox(
                  height: 115,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = snapshot.data![index];
                      String svgPath = svgAssets[index % svgAssets.length];
                      return _buildEventCard(
                        dateTime: event.dueDate,
                        title: event.name,
                        svgPath: svgPath,
                        context: context,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.8;

    return SizedBox(
      height: 150,
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
    required String dateTime,
    required String title,
    required String svgPath,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(RouterManger.livesession, arguments: widget.token);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 227, 241, 240),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    svgPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,maxLines: 1,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      dateTime,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
