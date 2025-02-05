import 'dart:async';
import 'package:elearning/providers/eventprovider.dart';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
    'assets/liveeventsvg/b (2).png',
    'assets/liveeventsvg/-books-96 (1).png',
    'assets/liveeventsvg/calander.png',
    'assets/liveeventsvg/b.png',
    'assets/liveeventsvg/books-80.png',
    'assets/liveeventsvg/calander1 (2).png',
    'assets/liveeventsvg/b (3).png',
    'assets/liveeventsvg/books-96.png',
    'assets/liveeventsvg/calander1.png',
  
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
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildShimmerEffect(context);
        } else 
        if (provider.error != null) {
          print(provider.error);
          return _buildShimmerEffect(context);
        } else if (provider.eventData.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                        height: 30,
                        child: Image.asset(
                          'assets/upcoming and continue learning (1)/upc (2).png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  height: 100,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: provider.eventData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = provider.eventData[index];
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
          return Container();
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
     final baseColor = Theme.of(context).primaryColor; // Base color from theme
  final gradientColors = generateGradientColors(baseColor);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(RouterManger.livesession, arguments: widget.token);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Container(
          decoration: BoxDecoration(
            //color:Theme.of(context).cardColor,
           gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors, // Dynamic gradient colors
      ),
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
                  child: 
                  svgPath.contains('.png')?Image.asset(svgPath,fit: BoxFit.contain,)
                  : SvgPicture.asset(
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
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      dateTime,
                      style: TextStyle(fontSize: 16.0,color: Colors.blue[200]),
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
  List<Color> generateGradientColors(Color baseColor) {
  final hslBase = HSLColor.fromColor(baseColor);

  // Generate three shades: base, mid, and light
  return [
    hslBase.withLightness((hslBase.lightness * 1).clamp(0.0, 1.0)).toColor(),
    hslBase.withLightness((hslBase.lightness * 1.5).clamp(0.0, 1.0)).toColor(),
    hslBase.withLightness((hslBase.lightness * 2.2).clamp(0.0, 1.0)).toColor(),
  ];
}

}
