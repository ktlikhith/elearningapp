// import 'package:elearning/services/homepage_service.dart';
// import 'package:elearning/ui/Webview/testweb.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class Certificatedetail extends StatefulWidget {
//   final String token;
//   final  String courseNmae;
//   final String certificatename;
//   final String issuedDate;
//   final String certificateurl;


//   const Certificatedetail({Key? key, required this.token,required this.courseNmae,required this.certificatename,required this.issuedDate,required this.certificateurl}) : super(key: key);

//   @override
//   _CertificateListPageState createState() => _CertificateListPageState();
// }

// class _CertificateListPageState extends State<Certificatedetail> {
 

//   @override
//   void initState() {
//     super.initState();
   
//   }

 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//          title: Text(widget.courseNmae, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: CourseCard(certificatename: widget.certificatename, issuedDate: widget.issuedDate, certificateurl: widget.certificateurl, token: widget.token,)
//     );
//   }
// }

// class CourseCard extends StatelessWidget {

//   final String certificatename;
//   final String issuedDate;
//   final String certificateurl;
//   final String token;

//   CourseCard({ required this.certificatename,required this.issuedDate,required this.certificateurl,required this.token});

//   @override
//   Widget build(BuildContext context) {
//      return GestureDetector(
//     onTap: ()=>Navigator.of(context).pop(),
//     child:Container(
//       width: MediaQuery.of(context).size.width*0.99,
//       height: MediaQuery.of(context).size.height*0.25,
      
//       decoration: BoxDecoration(

       
//         borderRadius: BorderRadius.only(
//           //topLeft: Radius.circular(16),
//                // bottomRight: Radius.circular(16),
//                topRight: Radius.circular(42),
//                 bottomLeft: Radius.circular(42)
//         ),
                     
//                         color: Theme.of(context).primaryColor,),
//       margin: EdgeInsets.all(10.0),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width*0.85,
//                    decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                   color: Theme.of(context).hintColor.withOpacity(0.6),
//                    ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       certificatename,
//                       maxLines:2,
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).highlightColor,
                        
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 Text(
//                   'Issued : ${issuedDate}',
//                   style: TextStyle(
//                     fontSize: 15.0,
//                     color: Theme.of(context).highlightColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 50,),
//                   Padding(
//                     padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.25),
//                     child: ElevatedButton(
//                                     onPressed: (){
//                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => WebViewPage('Certificate',certificateurl,token, ),
//                                         ),
//                       );
                    
//                                   },
                    
//                                     style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).cardColor,
//                                     ),
//                                     child: const Text(
//                     'DOWNLOAD',
//                     style: TextStyle(color: Colors.white),
//                                     ),
                                    
                                    
                                    
//                     ),
//                   ),
                                  
                
            
//               ],
//             ),
            

//           ],
//         ),
//       ),
    
//     ),
  
//      );
//   }


// }

import 'package:elearning/ui/Webview/testweb.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Certificatedetail extends StatefulWidget {
  final String token;
  final String courseNmae;
  final String certificatename;
  final String issuedDate;
  final String certificateurl;

  const Certificatedetail({
    Key? key,
    required this.token,
    required this.courseNmae,
    required this.certificatename,
    required this.issuedDate,
    required this.certificateurl,
  }) : super(key: key);

  @override
  _CertificatedetailState createState() => _CertificatedetailState();
}

class _CertificatedetailState extends State<Certificatedetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.courseNmae,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedCertificateIcon(),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.certificatename,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Issued: ${widget.issuedDate}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewPage(
                            'Certificate',
                            widget.certificateurl,
                            widget.token,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.download,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                      'DOWNLOAD',
                      style: TextStyle(color:Theme.of(context).primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
           
          ],
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
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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
      child: Icon(
        Icons.verified,
                        color: Color.fromARGB(255, 246, 232, 30),
        size: 100,
      ),
    );
  }
}
