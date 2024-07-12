import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/tanentlogo_service.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/upcoming_event.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Notification/notificationscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

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
  late Future<void> _fetchUserInfoFuture;
  late Future<void> _fetchOtherSectionsFuture;
  String _userName = '';
  String _userprofile = '';
  Uint8List? _tenantLogoBytes;
  int _notificationCount = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchUserInfoFuture = _fetchUserInfo(widget.token);
    _fetchOtherSectionsFuture = _fetchOtherSections();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _refreshNotificationCount();
    });
  }

  Future<void> _fetchUserInfo(String token) async {
    try {
      // Fetch data in parallel
      final results = await Future.wait([
        NotificationCount.getUnreadNotificationCount(token),
        SiteConfigApiService.getUserId(token),
        TanentLogo.fetchTenantUserData(token),
      ]);

      final count = results[0] as int;
      final userInfo = results[1] as Map<String, dynamic>;
      final logoData = results[2] as Map<String, dynamic>;

      final fullName = userInfo['fullname'];
      final userprofile = userInfo['userpictureurl'];

      Uint8List? tenantLogoBytes;
      if (logoData['tenant'].isNotEmpty) {
        final tenantLogoBase64 = logoData['tenant'][6]['tenant_logo'];
        if (tenantLogoBase64 != null && tenantLogoBase64.isNotEmpty) {
          tenantLogoBytes = base64Decode(tenantLogoBase64.split(',').last);
        }
      }

      setState(() {
        _notificationCount = count;
        _userName = fullName;
        _userprofile = userprofile;
        _tenantLogoBytes = tenantLogoBytes;
      });
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }

  Future<void> _fetchOtherSections() async {
    // This method can be used to load data for other sections if necessary
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // This will exit the app
        return false; // Returning false prevents the default back button behavior
      },
      child: Padding(
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
                  : FutureBuilder(
                      future: _fetchUserInfoFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Container(color: Colors.white),
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/logo/RAP_logo.jpeg',
                              fit: BoxFit.fill,
                            ),
                          );
                        }
                      },
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<void>(
  future: _fetchUserInfoFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildUserInfoSkeleton();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error loading user info'));
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Container(
          height: MediaQuery.of(context).size.height*0.08,
          color: Colors.grey[100], // Set the desired background color here
          padding: const EdgeInsets.all(0.0), // Add some padding if needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0,top: 12),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome, ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                           
                        ),
                      ),
                      TextSpan(
                        text: '$_userName!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor, // Set the color for the username
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Explore your courses and start learning.',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  },
),

                const SizedBox(height: 12.0),
                FutureBuilder<void>(
                  future: _fetchOtherSectionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          _buildLoadingSkeleton(),
                          const SizedBox(height: 15.0),
                          _buildLoadingSkeleton(),
                          const SizedBox(height: 15.0),
                          _buildLoadingSkeleton(),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading sections'));
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: AutoScrollableSections(token: widget.token),
                          ),
                          const SizedBox(height: 15.0),
                          UpcomingEventsSection(token: widget.token),
                          const SizedBox(height: 15.0),
                          CustomDashboardWidget(token: widget.token),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar:  Container( child: CustomBottomNavigationBar(initialIndex: 0, token: widget.token)),
        ),
      ),
    );
  }

  Widget _buildUserInfoSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20.0,
              width: 150.0,
              color: Colors.white,
            ),
            const SizedBox(height: 10.0),
            Container(
              height: 20.0,
              width: 250.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200.0,
        width: double.infinity,
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}
