// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/homepage_service.dart';
// import 'package:elearning/ui/Reports/Certificate_report/certificateDetail.dart';
// import 'package:elearning/ui/Webview/testweb.dart';
// import 'package:flutter/animation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CertificateListPage extends StatefulWidget {
//   final String token;

//   const CertificateListPage({Key? key, required this.token}) : super(key: key);

//   @override
//   _CertificateListPageState createState() => _CertificateListPageState();
// }

// class _CertificateListPageState extends State<CertificateListPage> {
//   late Future<List<CourseData>> futureFilteredCourses;

//   @override
//   void initState() {
//     super.initState();
//     futureFilteredCourses = _fetchAndFilterCourses();
//   }

//   Future<List<CourseData>> _fetchAndFilterCourses() async {
//     final homePageData = await HomePageService.fetchHomePageData(widget.token);
//     return homePageData.allCourses.where((course) => course.certificatename.isNotEmpty).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//          title: Text('Certificates', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           centerTitle: false,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: FutureBuilder<List<CourseData>>(
//         future: futureFilteredCourses,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Something went wrong'),);//Text('Error: ${snapshot.error}')
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No Certificates available'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return CourseCard(course: snapshot.data![index], token: widget.token);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class CourseCard extends StatelessWidget {
//   final CourseData course;
//   final String token;

//   CourseCard({required this.course, required this.token});

//   @override
//   Widget build(BuildContext context) {
//      return GestureDetector(
//     onTap:()=>Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => Certificatedetail(token: token, courseNmae: course.name, certificatename: course.certificatename, issuedDate: course.awarddate, certificateurl: course.certificateurl, ),
//                                       ),
//     ),
//     child:Container(
      
//       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Theme.of(context).hintColor.withOpacity(0.6),),
//       margin: EdgeInsets.all(10.0),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                        decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                       color: Theme.of(context).cardColor,
//                        ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           course.name,
//                           style: TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).highlightColor,
//                           ),
//                         ),
//                       ),
                      
//                     ),
//                     Icon(FontAwesomeIcons.certificate,color: Color.fromARGB(255, 246, 232, 30),)
                    
//                       // Image.asset(
//                       //     'assets/Reportsicon/juicy-framed-certificate.png',
//                       //     height: 30,
//                       //     width: 40,
//                       //     filterQuality:FilterQuality.none,
                            
//                       //                    ),

//                   ],
//                 ),
//                 SizedBox(height: 4.0),
//                 Text(
//                   'Issued : ${course.awarddate}',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
                
            
//               ],
//             ),
//              if (course.certificateurl!= null )
//                                     Padding(
//                                       padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08),
//                                       child: IconButton(
//                                         icon: const FaIcon(FontAwesomeIcons.download, color: Colors.black, size: 22),
//                                         onPressed: () {
//                                             Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => WebViewPage('Certificate',course.certificateurl,token, ),
//                                       ),
//                                                                         );
                                      
//                                         },
//                                       ),
//                                     ),

//           ],
//         ),
//       ),
//     ),
//      );
//   }


// }
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/Reports/Certificate_report/certificateDetail.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return homePageData.allCourses
        .where((course) => course.certificatename.isNotEmpty)
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificates',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
            return Center(child: Text('Something went wrong'));//Text('Error: ${snapshot.error}')
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

    void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Certificatedetail(
            token: token,
            courseNmae: course.name,
            certificatename: course.certificatename,
            issuedDate: course.awarddate,
            certificateurl: course.certificateurl,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
          // gradient: LinearGradient(
          //   colors: [Colors.blueAccent, Colors.lightBlueAccent],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,            
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Center(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.87,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).highlightColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                             Padding(
                               padding: const EdgeInsets.only(right: 5.0),
                               child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                 child: Image.network(
                                                       
                                                           '${course.courseImg}?token=${token}',
                                                           height: 45,
                                                           width: 70,
                                                           fit: BoxFit.fill,
                                                         
                                                           
                                                           errorBuilder: (context, error, stackTrace) {
                                                             return Image.asset(
                                  'assets/images/coursedefaultimg.jpg',
                                      height: 45,
                                                           width: 70,
                                  fit: BoxFit.fill,
                                                             );
                                                           },
                                                         ),
                               ),
                             ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: Text(
                                course.name,
                              maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                              SizedBox(width: 0),
                                Stack(children: [ Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 10),
                                  child: Image.asset("assets/Reportsicon/cert/3d-fluency-contract.png",width: 20,),
                                ),AnimatedCertificateIcon()]),
                    // Icon(
                    //   // FontAwesomeIcons.certificate,
                    //   Icons.verified,
                    //   color: Color.fromARGB(255, 246, 232, 30),
                    // ),
                          ],
                        ),
                        
                      ),
                    ),
                    
                
                  
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Issued : ${course.awarddate}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color:Theme.of(context).highlightColor,
                  ),
                ),
              ),
              Row(
                
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        
                children: [
                  ElevatedButton(onPressed: () {  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Certificatedetail(
                              token: token,
                              courseNmae: course.name,
                              certificatename: course.certificatename,
                              issuedDate: course.awarddate,
                              certificateurl: course.certificateurl,
                            ),
                          ),
                        ); },
                  child: Text('More Details',style:TextStyle(fontWeight:  FontWeight.bold,color: Theme.of(context).primaryColor),),
                                    ),
                                    ElevatedButton(  onPressed: () {if (course.certificateurl != null)
                                                                   _launchURL(course.certificateurl);
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder: (context) => WebViewPage(
                                                          //       'Certificate',
                                                          //       course.certificateurl,
                                                          //       token,
                                                          //     ),
                                                          //   ),
                                                          // );
                                                        },child: Row(
                                                          children: [
                                                            Text('Download',style:TextStyle(fontWeight:  FontWeight.bold,color: Theme.of(context).primaryColor),),
                                                            SizedBox(width: 8,),
                                                          
                                                         FaIcon(
                                                          FontAwesomeIcons.download,
                                                          color: Colors.black,
                                                          size: 20,
                                                        ),
                                                            
                                                          ],
                                                        ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AnimatedCertificateIcon extends StatefulWidget {
  @override
  _AnimatedCertificateIconState createState() => _AnimatedCertificateIconState();
}

class _AnimatedCertificateIconState extends State<AnimatedCertificateIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child:  Image.asset("assets/Reportsicon/cert/3d-fluency-contract.png",width: 40,)
      // FaIcon(
      //                 FontAwesomeIcons.forward,
      //                 color:Theme.of(context).highlightColor ,
      //                 size: 50,
      //               ),
    );
  }
}