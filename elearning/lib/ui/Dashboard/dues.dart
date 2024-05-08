import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elearning/services/homepage_service.dart'; // Import the HomePageService class
import 'package:shimmer/shimmer.dart';

class AutoScrollableSections extends StatefulWidget {
  final String token;

  const AutoScrollableSections({Key? key, required this.token}) : super(key: key);

  @override
  _AutoScrollableSectionsState createState() => _AutoScrollableSectionsState();
}

class _AutoScrollableSectionsState extends State<AutoScrollableSections> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _past = 0;
  int _soon = 0;
  int _later = 0;
  bool _isLoading = true; // Flag to track loading state

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _fetchHomePageData(); // Call method to fetch homepage data
  }

  Future<void> _fetchHomePageData() async {
    try {
      final homePageData = await HomePageService.fetchHomePageData(widget.token);
      setState(() {
        _past = homePageData.countActivity;
        _soon = homePageData.countSevenDays;
        _later = homePageData.countThirtyDays;
        _isLoading = false; // Update loading state
      });
    } catch (e) {
      print('Error fetching homepage data: $e');
      setState(() {
        _isLoading = false; // Update loading state in case of error
      });
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          // If reached the end, scroll back to the start
          _scrollController.animateTo(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        } else {
          // Scroll to the end
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              _isLoading ? _buildShimmerItem() : buildSection("Past Due", '$_past', const Color.fromARGB(255, 240, 37, 33),
                  'assets/images/svg/task-past-due-svgrepo-com.svg'),
              _isLoading ? _buildShimmerItem() : buildSection("Due Soon", '$_soon', const Color.fromARGB(255, 240, 222, 64),
                  'assets/images/svg/task-due-svgrepo-com.svg'),
              _isLoading ? _buildShimmerItem() : buildSection("Due Later", '$_later', Color.fromARGB(255, 107, 243, 80),
                  'assets/images/svg/date-time-svgrepo-com.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: const Color.fromARGB(255, 227, 236, 227),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String number, Color color, String svgPath) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: const Color.fromARGB(255, 227, 236, 227),
            width: 2.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: SvgPicture.asset(svgPath),
              ),
            ),
            const SizedBox(width: 25.0),
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7.0, width: 50.0),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
