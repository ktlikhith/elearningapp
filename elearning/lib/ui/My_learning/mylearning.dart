import 'package:elearning/ui/My_learning/buildsection.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:flutter/material.dart';



class MyLearningApp extends StatelessWidget {
  const MyLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
       const MyLearningPage();
    
  }
}

class MyLearningPage extends StatefulWidget {
  const MyLearningPage({super.key});

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
         backgroundColor: Theme.of(context).primaryColor,
        title: const Row(
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
            ? const PreferredSize(
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: const SingleChildScrollView(
       child:MyLearningAppBody()
        ),
        
    );
  }
}

class MyLearningAppBody extends StatelessWidget {
  const MyLearningAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 18.0),
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
          const SizedBox(height: 24.0), // Add some space between sections
          // Call buildCourseSection here
          buildCourseSection(), // This will display the course section
        ],
      ),
    );
  }
}



 


