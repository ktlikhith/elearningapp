import 'dart:async';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:elearning/providers/pastsoonlaterprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elearning/services/homepage_service.dart'; // Import the HomePageService class
import 'package:provider/provider.dart';
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
    return Consumer<activityprovider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: [
                _buildShimmerItem(),
                  _buildShimmerItem(),
                    _buildShimmerItem(),
              ],
            ),
          );
        }

        if (provider.error != null) {
             print('Error: ${provider.error}');
            return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: [
                _buildShimmerItem(),
                  _buildShimmerItem(),
                    _buildShimmerItem(),
              ],
            ),
          ); 
        
        }

        final activities = provider.activity;

        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  buildSection("Past Due", '${activities.isNotEmpty ? activities[0] : 0}', 
                      'assets/dashboardicons/due past.png'),
                  buildSection("Due Soon", '${activities.length > 1 ? activities[1] : 0}',  
                      'assets/dashboardicons/Due soon.png'),
                  buildSection("Due Later", '${activities.length > 2 ? activities[2] : 0}',
                      'assets/dashboardicons/due later.png'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      width: 200,
            height: 100,
      child: Shimmer.fromColors(
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
      ),
    );
  }

 Widget buildSection(String title, String number, String iconPath) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      clipBehavior: Clip.antiAlias,
      children: [
       
        Container(
          
          width: 200,
          height: 80,
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(
              color: Theme.of(context).cardColor,
            ),
            color: Theme.of(context).hintColor.withOpacity(0.1),
          ),
          child: Stack(
            children:[
               Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
              Positioned(
          right: -10,
          top: -15,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0),
                  bottomLeft: Radius.circular(45.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 19,
                    top: 22,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(4, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(iconPath, width: 30, height: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
            ],
          ),
        ),
           Container(
          width: 200,
          height: 80,
          padding: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(
              color: Theme.of(context).cardColor,
            ),
           
          ),
          ),
      
      ],
    ),
  );
}

}

class AnimatedCertificateIcon extends StatefulWidget {
  String iconPath;
  
  AnimatedCertificateIcon(this.iconPath);
  @override
  _AnimatedCertificateIconState createState() => _AnimatedCertificateIconState();
}

class _AnimatedCertificateIconState extends State<AnimatedCertificateIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child:  Image.asset(widget.iconPath,width: 40,color:Colors.black.withOpacity(0.4),),
      // FaIcon(
      //                 FontAwesomeIcons.forward,
      //                 color:Theme.of(context).highlightColor ,
      //                 size: 50,
      //               ),
    );
  }
}
