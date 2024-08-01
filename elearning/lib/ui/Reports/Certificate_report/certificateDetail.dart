import 'package:elearning/services/homepage_service.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Certificatedetail extends StatefulWidget {
  final String token;
  final  String courseNmae;
  final String certificatename;
  final String issuedDate;
  final String certificateurl;


  const Certificatedetail({Key? key, required this.token,required this.courseNmae,required this.certificatename,required this.issuedDate,required this.certificateurl}) : super(key: key);

  @override
  _CertificateListPageState createState() => _CertificateListPageState();
}

class _CertificateListPageState extends State<Certificatedetail> {
 

  @override
  void initState() {
    super.initState();
   
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(widget.courseNmae, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
      ),
      body: CourseCard(certificatename: widget.certificatename, issuedDate: widget.issuedDate, certificateurl: widget.certificateurl, token: widget.token,)
    );
  }
}

class CourseCard extends StatelessWidget {

  final String certificatename;
  final String issuedDate;
  final String certificateurl;
  final String token;

  CourseCard({ required this.certificatename,required this.issuedDate,required this.certificateurl,required this.token});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
    onTap: ()=>Navigator.of(context).pop(),
    child:Container(
      width: MediaQuery.of(context).size.width*0.99,
      height: MediaQuery.of(context).size.height*0.25,
      
      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.85,
                   decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).hintColor.withOpacity(0.6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      certificatename,
                      maxLines:2,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).highlightColor,
                        
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Issued : ${issuedDate}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.25),
                    child: ElevatedButton(
                                    onPressed: (){
                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage('Certificate',certificateurl,token, ),
                                        ),
                      );
                    
                                  },
                    
                                    style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).cardColor,
                                    ),
                                    child: const Text(
                    'DOWNLOAD',
                    style: TextStyle(color: Colors.white),
                                    ),
                                    
                                    
                                    
                    ),
                  ),
                                  
                
            
              ],
            ),
            

          ],
        ),
      ),
    
    ),
  
     );
  }


}