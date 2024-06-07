import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/report_service.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/My_learning/buildsection.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart'; 

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
   final ReportService reportService = ReportService();
    Report? reportData;

  void _handleSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }
   

  bool isLoading = false; // Simulated loading state

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Row(
            children: [
              Text(
                'My Learning',
              ),
            ],
          ),
         automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
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
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 1, token: widget.token),
      ),
    );
  }
}

class MyLearningAppBody extends StatefulWidget {
  final String token; // Add token field

  const MyLearningAppBody({Key? key, required this.token}) : super(key: key);

  @override
  _MyLearningAppBodyState createState() => _MyLearningAppBodyState();
}

class _MyLearningAppBodyState extends State<MyLearningAppBody> {
  bool _isLoading = true; // Initial loading state
  final ReportService reportService = ReportService();
  Report? reportData; // Define reportData property

  @override
  void initState() {
    super.initState();
    // Simulate data loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Set loading to false after delay
      });
    });
    fetchData(widget.token); // Fetch report data
  }

  // Fetch report data
  Future<void> fetchData(String token) async {
    try {
      final data = await reportService.fetchReport(token);
      setState(() {
        reportData = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Build method remains the same
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 18.0),
          SingleChildScrollView(
            
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                buildSection(
                  iconPath: 'assets/learning icons/total activity.png',
                  number: reportData?.totalNoActivity ?? 0,
                  title: 'Totalactivity',
                  context:context,
                ),
                buildSection(
                  iconPath: 'assets/learning icons/Completed Activity.png',
                  number: reportData?.completedActivity ?? 0,
                  title: 'Completed',
                      context:context,
                ),
                buildSection(
                  iconPath: 'assets/learning icons/Average.png',
                  number: reportData?.averageGrade ?? 0,
                  title: 'Avg_Grade',
                      context:context,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0), // Add some space between sections
          // Shimmer effect while loading BuildCourseSections
          _isLoading
              ? _buildLoadingShimmer()
              : BuildCourseSections(token: widget.token), // Pass the token to BuildCourseSections
        ],
      ),
    );
  }

  // Build loading shimmer effect
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3, // Show 3 dummy containers while loading
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200, // Adjust height as needed
                  color: Colors.grey, // Placeholder color for the video
                ),
                const SizedBox(height: 16.0), // Add spacing between video section and other content
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.grey, // Placeholder color for title
                ),
                const SizedBox(height: 8.0), // Add spacing between title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.0,
                      height: 12.0,
                      color: Colors.grey, // Placeholder color for status
                    ),
                    const SizedBox(width: 16.0), // Add spacing between status and due date
                    Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors.grey, // Placeholder color for due date
                    ),
                  ],
                ),
                const SizedBox(height: 8.0), // Add spacing between status and download/more options
              ],
            ),
          ),
        );
      },
    );
  }
}
