import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/material.dart';

class CertificateListPage extends StatefulWidget {
  final String token;

  const CertificateListPage({Key? key, required this.token}) : super(key: key);

  @override
  _CertificateListPageState createState() => _CertificateListPageState();
}

class _CertificateListPageState extends State<CertificateListPage> {
  late Future<List<CourseData>> futureFilteredCourses;

  @override
  void initState() {
    super.initState();
    futureFilteredCourses = _fetchAndFilterCourses();
  }

  Future<List<CourseData>> _fetchAndFilterCourses() async {
    final homePageData = await HomePageService.fetchHomePageData(widget.token);
    return homePageData.allCourses.where((course) => course.certificatename.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Certificates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<CourseData>>(
        future: futureFilteredCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Certificates available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CourseCard(course: snapshot.data![index], token: widget.token);
              },
            );
          }
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseData course;
  final String token;

  CourseCard({required this.course, required this.token});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Award Date: ${course.awarddate}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            
          ],
        ),
      ),
    );
  }

  
}
