import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/providers/Companylogoprovider.dart';
import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/providers/Reward_data_provider.dart';
import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/providers/eventprovider.dart';
import 'package:elearning/providers/pastsoonlaterprovider.dart';
import 'package:elearning/providers/profile_provider.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/tanentlogo_service.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/upcoming_event.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Notification/notificationscreen.dart';
import 'package:elearning/ui/download/downloadmanager.dart';
import 'package:elearning/utilites/networkerrormsg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
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
 
  String _userName = '';
  String _userprofile = '';
  Uint8List? _tenantLogoBytes;
  int _notificationCount = 0;
  DownloadManager dm=new DownloadManager();
  // late Timer _timer;

  @override
  void initState() {
    super.initState();
   // _fetchUserInfoFuture = _fetchUserInfo(widget.token);
  
   dm.userpermission(context);
  context.read<EventProvider>().fetchEvent();
   
  initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   _refreshNotificationCount();
    // });
  }


Future<void>  _refreshdata()async{

     
   // _fetchUserInfoFuture = _fetchUserInfo(widget.token);
   
       context.read<activityprovider>().fetchpastsoonlater();
       
          //  Provider.of<ReportProvider>(context, listen: false).fetchData();
           context.read<ProfileProvider>().fetchProfileData();
          context.read<ReportProvider>().fetchData();
          context.read<EventProvider>().fetchEvent();
          context.read<TenantLogoProvider>().fetchTenantUserData();
          context.read<LearningPathProvider>().fetchLearningPaths();
            context.read<HomePageProvider>().fetchAllCourses();
            context.read<RewardProvider>().fetchRewardPoints();
              context.read<RewardProvider>().fetchSpinWheelData();
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   _refreshNotificationCount();
    // });
    setState(() {});
        
      }

  // Future<void> _fetchUserInfo(String token) async {
  
  //   try {
  //     // Fetch data in parallel
  //     final results = await Future.wait([
  //       NotificationCount.getUnreadNotificationCount(token),
  //       SiteConfigApiService.getUserId(token),
  //       TanentLogo.fetchTenantUserData(token),
  //     ]);

  //     final count = results[0] as int;
  //     final userInfo = results[1] as Map<String, dynamic>;
  //     final logoData = results[2] as Map<String, dynamic>;

  //     final fullName = userInfo['fullname'];
  //     final userprofile = userInfo['userpictureurl'];

  //     Uint8List? tenantLogoBytes;
  //     if (logoData['tenant'].isNotEmpty) {
  //       final tenantLogoBase64 = logoData['tenant'][6]['tenant_logo'];
  //       if (tenantLogoBase64 != null && tenantLogoBase64.isNotEmpty) {
  //         tenantLogoBytes = base64Decode(tenantLogoBase64.split(',').last);
  //       }
  //     }
      

  //     setState(() {
  //       _notificationCount = count;
  //       _userName = fullName;
  //       _userprofile = userprofile;
  //       _tenantLogoBytes = tenantLogoBytes;
  //     });
  //   } catch (e) {
  //     print('Error fetching user information: $e');
  //   }
  // }

 
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
  padding: EdgeInsets.only(right: 10.0, left: 0),
  child: Consumer<TenantLogoProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        // Show shimmer loading effect while data is being fetched
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SizedBox(
            width: 90,
            height: 40,
            child: Container(color: Colors.white),
          ),
        );
      } else if (provider.error != null) {
      
  // Check if the error is ClientException and contains 'Connection reset by peer'
  if (provider.error.toString().contains('Connection reset by peer')||provider.error.toString().contains('Connection timed out')||provider.error.toString().contains('ClientException with SocketException: Failed host lookup')) {
    // Call your custom function to handle the error
    showNetworkError(context);
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
  } else{
    // Show the general error message to the user
    SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong please try again.'
)),
    );
    });
        // Handle error state - fallback to default logo
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


    
      } else if (provider.tenantData != null &&
          provider.tenantData!['logoBytes'] != null) {
        // Display fetched tenant logo
        final Uint8List tenantLogoBytes =
            provider.tenantData!['logoBytes'] as Uint8List;

        return Container(
          width: 90,
          height: 40,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              tenantLogoBytes,
              fit: BoxFit.contain,
            ),
          ),
        );
      } else {
        // Default fallback if no data is available
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
                   
                  },
                  child:  Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
           return Container();
          }

          if (profileProvider.errorMessage != null) {
            // Check if the error is ClientException and contains 'Connection reset by peer'
  if (profileProvider.errorMessage.toString().contains('Connection reset by peer')||profileProvider.errorMessage.toString().contains('Connection timed out')||profileProvider.errorMessage.toString().contains('ClientException with SocketException: Failed host lookup')) {
    // Call your custom function to handle the error
  showNetworkError(context);
      return Container();
  } else{
    // Show the general error message to the user
    SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong please try again.'
)),
    );
    });
        
        return Container();
  }


    
          }
          

          if (profileProvider.profileData != null) {
 
             final data = profileProvider.profileData;
                return  CircleAvatar(
                    radius: 20,
                    backgroundImage: profileProvider.profileData!=null ? NetworkImage(data!['profilePictureUrl']
                    )
                     : null,
                  );
          }
        final data = profileProvider.profileData;
           return  CircleAvatar(
                    radius: 20,
                    backgroundImage: profileProvider.profileData!=null ? NetworkImage(data!['profilePictureUrl']
                    )
                     : null,
                  );
        }
        
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
          Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return _buildUserInfoSkeleton();
          }

          if (profileProvider.errorMessage != null) {
          
                       // Check if the error is ClientException and contains 'Connection reset by peer'
  if (profileProvider.errorMessage.toString().contains('Connection reset by peer')||profileProvider.errorMessage.toString().contains('Connection timed out')||profileProvider.errorMessage.toString().contains('ClientException with SocketException: Failed host lookup')) {
  
      return _buildUserInfoSkeleton();
  } else{
    // Show the general error message to the user
    SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong please try again.'
)),
    );
    });
        // Handle error state - fallback to default logo
        return _buildUserInfoSkeleton();
  }
          }

          if (profileProvider.profileData != null) {
            
                  
              
       
                 final data = profileProvider.profileData;
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
                              text:    data!['studentName'],
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
              }else{
                 context.read<ProfileProvider>().fetchProfileData();
                 return _buildUserInfoSkeleton();
              }
            },
          ),
          SizedBox(height: 12.0),
           Column(
                  children: [
                    AutoScrollableSections(token: widget.token),
                    SizedBox(height: 15.0),
                    UpcomingEventsSection(token: widget.token),
                    SizedBox(height: 15.0),
                    CustomDashboardWidget(token: widget.token),
                  ],
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
    return Container(
     
      child: Shimmer.fromColors(
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
      ),
    );
  }

Widget _buildLoadingSkeleton() {
  return SizedBox(
    height: 200.0, // Ensure it has fixed constraints
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
    ),
  );
}

}
