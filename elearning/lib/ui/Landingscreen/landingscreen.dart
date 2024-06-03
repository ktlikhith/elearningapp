import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.all(15.0),
                  child: _buildPage(
                    pagesData[index]['gif']!,
                    pagesData[index]['title']!,
                    pagesData[index]['subtitle']!,
                    screenHeight,
                    screenWidth,
                    isLastPage: index == pagesData.length - 1,
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 20,
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
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pagesData.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),
            if (_currentPage == pagesData.length - 1)
              Positioned(
                bottom: 20,
                right: 20,
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  Widget _buildPage(String gifPath, String title, String subtitle, double screenHeight, double screenWidth, {bool isLastPage = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          gifPath,
          fit: BoxFit.fitWidth,
          width: screenWidth,
          height: screenHeight * 0.6,
        ),
        SizedBox(height: screenHeight * 0.03),
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
            color: Colors.grey[800],
          ),
        ),
        if (isLastPage) SizedBox(height: screenHeight * 0.15),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
