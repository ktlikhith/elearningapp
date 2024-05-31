import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/tanentlogo_service.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/upcoming_event.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Notification/notificationscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

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
  String _userprofile = '';
  Uint8List? _tenantLogoBytes;
  int _notificationCount = 0;
  late Timer _timer;
  bool _isUserInfoLoaded = false; // Flag to track if user info is loaded

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(widget.token);
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _refreshNotificationCount();
      
    });
  }

  Future<void> _fetchUserInfo(String token) async {
    try {
      // Fetch user data from the server
      final count = await NotificationCount.getUnreadNotificationCount(token);
      final userInfo = await SiteConfigApiService.getUserId(token);
      final fullName = userInfo['fullname'];
      final userprofile = userInfo['userpictureurl'];
      final logoData = await TanentLogo.fetchTenantUserData(token);

      if (logoData['tenant'].isNotEmpty) {
        final tenantLogoBase64 = logoData['tenant'][6]['tenant_logo'];
        if (tenantLogoBase64 != null && tenantLogoBase64.isNotEmpty) {
          final Uint8List tenantLogoBytes = base64Decode(tenantLogoBase64.split(',').last);
          setState(() {
            _tenantLogoBytes = tenantLogoBytes;
          });
        }
      } else {
        setState(() {
          _tenantLogoBytes = null;
        });
      }

      setState(() {
        _notificationCount = count;
        _userName = fullName;
        _userprofile = userprofile;
        _isUserInfoLoaded = true;
      });
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
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Dashboard'),
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
                : _isUserInfoLoaded
                    ? SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          'assets/logo/RAP_logo.jpeg',
                          fit: BoxFit.fill,
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Container(color: Colors.white),
                        ),
                      ),
          ),
          actions: <Widget>[
            Stack(
              children: [
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.bell,
                    color: Colors.white,
                  ),
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
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
                  Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
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
        body: _isUserInfoLoaded
            ? SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Welcome, $_userName!',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Text(
                          'Explore your courses and start learning.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
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
              )
            : _buildLoadingSkeleton(), // Show loading skeleton while data is loading
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0, token: widget.token),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return !_isUserInfoLoaded
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 65.0,
                    width: 100,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  SizedBox(height: 15.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 200.0,
                        color: Colors.grey, // Placeholder color for status
                      ),
                      const SizedBox(height: 16.0), // Add spacing between status and due date
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 210.0,
                        color: Colors.grey, // Placeholder color for due date
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 210.0,
                        color: Colors.grey, // Placeholder color for due date
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color.fromARGB(255, 122, 121, 121),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 175, 175, 175)!,
                          highlightColor: const Color.fromARGB(255, 161, 160, 160)!,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : SizedBox(); // Return an empty SizedBox if user info is loaded
  }
}
