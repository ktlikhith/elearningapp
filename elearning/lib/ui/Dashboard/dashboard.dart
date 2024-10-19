import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'dart:developer' as developer;
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
   ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;
 
  
  late Future<void> _fetchUserInfoFuture;
  late Future<void> _fetchOtherSectionsFuture;
  String _userName = '';
  String _userprofile = '';
  Uint8List? _tenantLogoBytes;
  int _notificationCount = 0;
  // late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchUserInfoFuture = _fetchUserInfo(widget.token);
   _fetchOtherSectionsFuture = _fetchOtherSections();
   
  initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   _refreshNotificationCount();
    // });
  }

Future<void>  _refreshdata()async{

     
    _fetchUserInfoFuture = _fetchUserInfo(widget.token);
   _fetchOtherSectionsFuture = _fetchOtherSections();
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   _refreshNotificationCount();
    // });
    setState(() {});
        
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
  // Stream<int> noticount() async*{
  //    try {
  //     Stream count = await NotificationCount().getUnreadNotificationCountStream(widget.token);
  //     yield count;
  //   } catch (e) {
  //     print('Error refreshing notification count: $e');
  //   }

  // }

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
    // _timer.cancel();
        _connectivitySubscription.cancel();
    super.dispose();
  }  
  // Initialize connectivity
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  // Update connectivity status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _dismissNoInternetDialog();
    }
  }

  // Show No Internet Dialog
  void _showNoInternetDialog() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opss No Internet Connection..'),
            content: const Text('Please check your connection. You can try reloading the page or explore the available offline content.'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Reload'),
                    onPressed:_refreshdata ,
                    // onPressed: () async {
                    //   final result = await _connectivity.checkConnectivity();
                    //   _updateConnectionStatus(result);
                    // },
                  ),
                                ElevatedButton(onPressed:(){  Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);}, child:  const Text('Offline Content'),),
                ],
              ),

              
            ],
          );
        },
      );
    }
  }

  // Dismiss No Internet Dialog
  void _dismissNoInternetDialog() {
    if (isDialogOpen) {
      _refreshdata();
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
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
            automaticallyImplyLeading: false,
            title:  Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.0,left: 0),
                  child: _tenantLogoBytes != null
                      ? Container(
                     
                          width: 90,
                          height: 40,
                          color:Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _tenantLogoBytes!,
                              fit: BoxFit.contain,
                            ),
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
                                  width: 90,
                                  height: 40,
                                  child: Container(color: Colors.white),
                                ),
                              );
                            } else {
                              return Container(
                                
                                width: 90,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/logo/RAP_logo.jpeg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                    
                ),
               
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            
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
                  StreamBuilder<int>(
                    stream: NotificationCount().getUnreadNotificationCountStream(widget.token),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            snapshot.data.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                      }
                      else return Container();
                    }
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () async{
                   await Navigator.of(context).pushNamed(RouterManger.myprofile, arguments: widget.token);
                   _refreshdata();
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
         body: RefreshIndicator(

        triggerMode:RefreshIndicatorTriggerMode.anywhere,
       onRefresh:_refreshdata,
      child:
        SingleChildScrollView(
           physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<void>(
            future: _fetchUserInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildUserInfoSkeleton();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading user info'));
              } else {
                return Container(
                  width:MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome, ',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '$_userName!',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Explore your courses and start learning.',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: 12.0),
          FutureBuilder<void>(
            future: _fetchOtherSectionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    _buildLoadingSkeleton(),
                    SizedBox(height: 15.0),
                    _buildLoadingSkeleton(),
                    SizedBox(height: 15.0),
                    _buildLoadingSkeleton(),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading sections'));
              } else {
                return Column(
                  children: [
                    AutoScrollableSections(token: widget.token),
                    SizedBox(height: 15.0),
                    UpcomingEventsSection(token: widget.token),
                    SizedBox(height: 15.0),
                    CustomDashboardWidget(token: widget.token),
                  ],
                );
              }
            },
          ),
        ],
              ),
            ),
         ),
  bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0, token: widget.token),
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
