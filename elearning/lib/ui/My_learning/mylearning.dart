import 'package:elearning/ui/My_learning/buildsection.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:flutter/material.dart';



class MyLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
       MyLearningPage();
    
  }
}

class MyLearningPage extends StatefulWidget {
  @override
  _MyLearningPageState createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  bool _isSearching = false;

  void _handleSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'My Learning App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _handleSearchPressed,
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
       child:MyLearningAppBody()
        ),
    );
  }
}

class MyLearningAppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 18.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                buildSection(
                  icon: Icons.home,
                  number: 5,
                  title: 'My Playlists',
                ),
                buildSection(
                  icon: Icons.person,
                  number: 3,
                  title: 'Saved',
                ),
                buildSection(
                  icon: Icons.settings,
                  number: 8,
                  title: 'Downloads',
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0), // Add some space between sections
          // Call buildCourseSection here
          buildCourseSection(), // This will display the course section
        ],
      ),
    );
  }
}



 


