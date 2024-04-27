import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
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
                    ),
                    child: Text('Skip'),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Color.fromARGB(255, 242, 242, 243),
                  elevation: 6,
                ),
                child: Text('Login',style: TextStyle(color:  Colors.orange),),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(String gifPath, String title, String subtitle,
      {bool isLastPage = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          gifPath,
          fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 8, 8, 8),
          ),
        ),
        if (isLastPage) SizedBox(height: 100),
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
