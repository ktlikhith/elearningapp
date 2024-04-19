import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/login_page/login_screen.dart';
import 'package:flutter/material.dart';


// class LandingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Corporate eLearning App',
//       theme: ThemeData(
//         primaryColor: Color(0xFF007bff), // Accent Color: Yellow
//         scaffoldBackgroundColor: Color(0xFFF8F9FA), // Background Color: Light Gray
//         textTheme: TextTheme(
//           headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
//           bodyText1: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
//         ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFC107)),
//       ),
//       home: LandingPage(),
//     );
//   }
// }

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> pagesData = [
    {
      'gif': 'assets/gif/Animation - 1713382291232.gif',
      'title': 'Discover New Skills',
      'subtitle': 'Explore a wide range of courses tailored for your professional growth.',
    },
    {
      'gif': 'assets/gif/Animation - 1713381464815.gif',
      'title': 'Interactive Learning',
      'subtitle': 'Engage with interactive lessons and quizzes for effective learning.',
    },
    {
      'gif': 'assets/gif/Animation - 1713381378792.gif',
      'title': 'Join Now!',
      'subtitle': 'Sign in to unlock the full potential of our eLearning platform.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your branding background color here
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
              return _buildPage(
                pagesData[index]['gif']!,
                pagesData[index]['title']!,
                pagesData[index]['subtitle']!,
                isLastPage: index == pagesData.length - 1,
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
                    child: Text('Skip'),
                  )
                : SizedBox(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pagesData.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _currentPage == pagesData.length - 1
                ? ElevatedButton(
  onPressed: () {
 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
  },
  child: Text('Login'),
)
                : SizedBox(),
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
          fit: BoxFit.fitWidth, // Ensure the image fits the width of the screen
          width: MediaQuery.of(context).size.width, // Set the width to the screen width
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
        if (isLastPage) SizedBox(height: 100), // Add some space for the login button
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}