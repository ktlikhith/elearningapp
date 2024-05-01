import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/upcoming_event.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Notification/notificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';
import 'dart:convert'; 
import 'dart:async';





class DashboardScreen extends StatelessWidget {
  final String token;

  const DashboardScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardPage(token: token); // Pass the token to DashboardPage
  }
}



class DashboardPage extends StatefulWidget {
  final String token;

  const DashboardPage({Key? key, required this.token}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
  
  
  
}
 


class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String _userName = ''; 
  String _userprofile='';// Default value set to an empty string
  Uint8List? _tenantLogoBytes;
  int _notificationCount= 0;
  late Timer _timer;

 @override
  void initState() {
    super.initState();
    _fetchUserInfo(widget.token);
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _refreshNotificationCount(); // Call the method to refresh notification count every 3 seconds
    });
    
  }




 Future<void> _fetchUserInfo(String token) async {
  try {
    final count = await NotificationCount.getUnreadNotificationCount(token);
    final userInfo = await SiteConfigApiService.getUserId(token);
    final fullName = userInfo['fullname'];
    final userprofile = userInfo['userpictureurl'];
    final logoData = await TanentLogo.fetchTenantUserData(token);
    final tenantLogoBase64 = logoData['tenant'][6]['tenant_logo'];

    // Check if tenantLogoBase64 is null or empty
    if (tenantLogoBase64 != null && tenantLogoBase64.isNotEmpty) {
      // Decode base64 string to Uint8List
      final Uint8List tenantLogoBytes = base64Decode(tenantLogoBase64.split(',').last);
      setState(() {
        _notificationCount = count;
        _userName = fullName;
        _userprofile = userprofile;
        _tenantLogoBytes = tenantLogoBytes;
      });
    } else {
      setState(() {
        _userName = fullName;
        _userprofile = userprofile;
        _tenantLogoBytes = null; // Set logo bytes to null if data is empty
      });
    }
  } catch (e) {
    print('Error fetching user information: $e');
  }
}

 Future<void> _refreshNotificationCount() async {
    try {
      final count = await NotificationCount.getUnreadNotificationCount(widget.token);
      setState(() {
        _notificationCount = count;
      });
    } catch (e) {
      print('Error refreshing notification count: $e');
    }
  }

@override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  





  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        //    title: const Text(
        //   // 'Dashboard',
        // ),
          backgroundColor: Theme.of(context).primaryColor,
         
          elevation: 0,
          leading: Padding(
           padding: EdgeInsets.all(8.0),
            child: _tenantLogoBytes != null
                ? SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.memory(
                      _tenantLogoBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox.shrink(), // Render an empty SizedBox if logo data is not available
          ),
          
          
         actions: <Widget>[
            Stack(
        children: [
      IconButton(
        icon: FaIcon(FontAwesomeIcons.bell,color: Colors.white,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(token: widget.token),
            ),
          );
        },
      ),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(4), // Adjust padding as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red, // Customize badge background color here
          ),
          child: Text(
            '$_notificationCount',
            style: TextStyle(
              color: Colors.white, // Customize text color here
              fontSize: 12, // Adjust font size as needed
            ),
          ),
        ),
      ),
        ],
      ),
      
                 
            
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(RouterManger.myprofile,arguments:widget.token);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: _userprofile.isNotEmpty ? NetworkImage(_userprofile) : null,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text(
                    'Welcome, $_userName!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                  child: Text(
                    'Explore your courses and start learning.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
               
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: AutoScrollableSections(token: widget.token),
                ),
                const SizedBox(height: 15.0),
                
                 UpcomingEventsSection(token: widget.token),
                
                const SizedBox(height: 15.0),
                CustomDashboardWidget(token: widget.token),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0,token: widget.token),
      ),
    );
  }
}
