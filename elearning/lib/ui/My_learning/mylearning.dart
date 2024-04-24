import 'package:elearning/ui/My_learning/buildsection.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  final String token;

  const LearningScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyLearningPage(token: token);
  }
}

class MyLearningPage extends StatefulWidget {
  final String token;

  const MyLearningPage({Key? key, required this.token}) : super(key: key);

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
                fontWeight: FontWeight.bold,color: Colors.white
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,color: Colors.white),
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
      body: SingleChildScrollView(
        child: MyLearningAppBody(token: widget.token), // Pass the token to MyLearningAppBody
      ),
      bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 1,token: widget.token,),
    );
  }
}

class MyLearningAppBody extends StatelessWidget {
  final String token; // Add token field

  const MyLearningAppBody({Key? key, required this.token}) : super(key: key);

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
                  icon: Icons.video_library_outlined,
                  number: 5,
                  title: 'My Playlists',
                ),
                buildSection(
                  icon: Icons.save,
                  number: 3,
                  title: 'Saved',
                ),
                buildSection(
                  icon: Icons.download,
                  number: 8,
                  title: 'Downloads',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0), // Add some space between sections
          // Call buildCourseSection here
          BuildCourseSections(token: token,), // Pass the token to BuildCourseSections
        ],
      ),
    );
  }
}
