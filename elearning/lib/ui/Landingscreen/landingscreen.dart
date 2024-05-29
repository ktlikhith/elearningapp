import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isConnected = true;

  List<Map<String, String>> pagesData = [
    {
      'gif': 'assets/gif/landing6.gif',
      'title': 'Discover New Skills',
      'subtitle': 'Explore a wide range of courses tailored for your professional growth.',
    },
    {
      'gif': 'assets/gif/loginbg7.gif',
      'title': 'Interactive Learning',
      'subtitle': 'Engage with interactive lessons and quizzes for effective learning.',
    },
    {
      'gif': 'assets/gif/landing5.gif',
      'title': 'Join Now!',
      'subtitle': 'Sign in to unlock the full potential of our eLearning platform.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHorizontal = screenWidth * 0.04;
    final double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pagesData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: _buildPage(
                    pagesData[index]['gif']!,
                    pagesData[index]['title']!,
                    pagesData[index]['subtitle']!,
                    isLastPage: index == pagesData.length - 1,
                    screenHeight: screenHeight,
                  ),
                );
              },
            ),
            Positioned(
              top: screenHeight * 0.05,
              right: screenWidth * 0.05,
              child: _currentPage < pagesData.length - 1
                  ? ElevatedButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          pagesData.length - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          backgroundColor: Theme.of(context).secondaryHeaderColor),
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SizedBox(),
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pagesData.length,
                  (index) => _buildDot(index, screenWidth),
                ),
              ),
            ),
            if (_currentPage == pagesData.length - 1)
              Positioned(
                bottom: screenHeight * 0.05,
                right: screenWidth * 0.05,
                child: ElevatedButton(
                  onPressed: _isConnected
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                      : null, // Disable button if not connected
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: buttonHeight * 0.3),
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    elevation: 6,
                  ),
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
              ),
            if (!_isConnected)
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please check your internet connection',
                        style: TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: _checkInternetConnection,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String gifPath, String title, String subtitle,
      {bool isLastPage = false, required double screenHeight}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          gifPath,
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: screenHeight * 0.6,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          title,
          style: TextStyle(
            fontSize: screenHeight * 0.03,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            color: Colors.grey[600],
          ),
        ),
        if (isLastPage) SizedBox(height: screenHeight * 0.1),
      ],
    );
  }

  Widget _buildDot(int index, double screenWidth) {
    return Container(
      width: screenWidth * 0.025,
      height: screenWidth * 0.025,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
