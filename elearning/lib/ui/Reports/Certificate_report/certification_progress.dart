import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/Reports/Certificate_report/certificateDetail.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
     return GestureDetector(
    onTap:()=>Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Certificatedetail(token: token, courseNmae: course.name, certificatename: course.certificatename, issuedDate: course.awarddate, certificateurl: course.certificateurl, ),
                                      ),
    ),
    child:Container(
      
      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).hintColor.withOpacity(0.6),),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                   ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      course.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Issued : ${course.awarddate}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                
            
              ],
            ),
             if (course.certificateurl!= null )
                                    Padding(
                                      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08),
                                      child: IconButton(
                                        icon: const FaIcon(FontAwesomeIcons.download, color: Colors.black, size: 22),
                                        onPressed: () {
                                            Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewPage('Certificate',course.certificateurl,token, ),
                                      ),
                                                                        );
                                      
                                        },
                                      ),
                                    ),

          ],
        ),
      ),
    ),
     );
  }


}