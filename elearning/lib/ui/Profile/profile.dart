// import 'dart:convert';
// import 'package:clay_containers/widgets/clay_container.dart';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/profile_service.dart';
// import 'package:elearning/ui/Profile/achivement.dart';
// import 'package:elearning/ui/Profile/progressbar.dart';
// import 'package:elearning/ui/Profile/rank_level.dart';
// import 'package:elearning/ui/Profile/updateProfile.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shimmer/shimmer.dart'; 

// class ProfilePage extends StatefulWidget {
//   final String token;

//   const ProfilePage({Key? key, required this.token}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late String _profilePictureUrl = '';
//   late String _studentName = '';
//   late String _studentEmail = '';
//   late String _department = '';
//   var  _userPoints = '';
//   var _badgesEarn = 0;
//   var _userLevel = '';
//   var _completioned ;
//   var _inProgress ;
//   var _totalNotStarted ;
//   bool _isLoading = true; // Add loading state
  

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData(widget.token);
//   }

//   Future<void> _fetchProfileData(String token) async {
//     try {
//       final data = await ProfileAPI.fetchProfileData(token);
      

//       setState(() {
//         _studentName = data['user_info'][0]['studentname'];
//         _studentEmail = data['user_info'][0]['studentemail'];
//         _department = data['user_info'][0]['department'];
//         final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
       
//         if (profilePictureMatch != null) {
//           _profilePictureUrl = profilePictureMatch.group(1)!;
         
//         }

//         final achievements = data['achievements'][0];
//        _userPoints =  achievements['userpoints'];
//         _badgesEarn = achievements['badgesearn'];
//         _userLevel =  achievements['userlevel'];

//         final courseProgress = data['course_progress'];
//         _completioned = courseProgress['completioned'];
//         _inProgress = courseProgress['inprogress'];
//         _totalNotStarted = courseProgress['totalnotstarted'];

        
        

//         _isLoading = false; // Update loading state
//       });
//     } catch (e) {
//       print('Error fetching profile data: $e');
//       _isLoading = false; // Handle loading state on error
//     }
//   }

//   bool effectEnabled = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true, // Extend the background behind the app bar
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text('User Profile'),
//         titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back,color: Colors.white,),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit,color: Theme.of(context).backgroundColor,),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(token: widget.token)));
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Center(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: EdgeInsets.only(top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 20),
//               child: _isLoading
//                   ? _buildLoadingSkeleton() // Show shimmer skeleton while loading
//                   : Column(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           // padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
//                           child: Column(
//                             // crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                             ClayContainer(
                              
//           color: Color.fromARGB(255, 227, 241, 240),
//           height: MediaQuery.of(context).size.height*0.23,
//           width: MediaQuery.of(context).size.width*0.9,
//           borderRadius: MediaQuery.of(context).size.height*1,
//           customBorderRadius: BorderRadius.only(
//               topRight: Radius.elliptical(150, 150),
//               bottomLeft: Radius.circular(50)),
        
//                                 // padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 0),
//                                 child: Column(
//                                   children: [
//                                      const SizedBox(height: 20),
//                                     Stack(
                                      
//                                       alignment: Alignment.bottomRight,
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 50,
//                                           backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       _studentName,
//                                       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                                     ),
//                                     // const SizedBox(height: 8),
//                                     Text(
//                                       _studentEmail,
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
  
//                                   ],
//                                 ),
//                               ),
//                              const SizedBox(height: 10),
//                               RankLevel(token: widget.token),
//                                    ],
//                           ),
//                         ), // Use RankLevel widget here
//                               const SizedBox(height: 5),
//                               buildAchievementUI(),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAchievementUI() {
//   // Build your achievement UI here
//     double screenWidth = MediaQuery.of(context).size.width;
//   return Container(
//     width: 370,
//     padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
//           spreadRadius: 1,
//           blurRadius: 3,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
        
//         const Text(
//           'Achievements',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             buildAchievement(_userPoints, 'Points', 'assets/profileicons/Points.png'),
//             buildAchievement(_badgesEarn.toString(), 'Badges', 'assets/profileicons/Badges.png'),
//             buildAchievement(_userLevel, 'Level', 'assets/profileicons/Level.png'),
//           ],
//         ),
//          const SizedBox(height: 10), // Add some space below the achievements row
//         Divider( // Add a divider
//           height: 1, // Set the height of the divider
//           thickness: 1, // Set the thickness of the divider line
//           color: Colors.grey[300], // Set the color of the divider line
//         ),
//         const SizedBox(height: 25),
//         const Text(
//             'Progress',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ), // Add some space below the existing row
//         buildProgressBar('Completed', _completioned), 
//         buildProgressBar('In Progress', _inProgress),
//         buildProgressBar('Total Not Started', _totalNotStarted),
//       ],
//     ),
//   );
// }


//   Widget _buildLoadingSkeleton() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: 150,
//             height: 20,
//             color: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: 100,
//             height: 20,
//             color: Colors.white,
//           ),
//           SizedBox(height: 30),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Achievements',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       color: Colors.white,
//                     ),
//                     Container(
//                       width: 50,
//                       height: 50,
//                       color: Colors.white,
//                     ),
//                     Container(
//                       width: 50,
//                       height: 150,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Progress',
//             style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: 400,
//             height: 20,
//             color: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: 400,
//             height: 20,
//             color: Colors.white,
//           ),
//           SizedBox(height: 10),
//           Container(
//             width: 400,
//             height: 20,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/profile_service.dart';
import 'package:elearning/ui/Profile/achivement.dart';
import 'package:elearning/ui/Profile/progressbar.dart';
import 'package:elearning/ui/Profile/rank_level.dart';
import 'package:elearning/ui/Profile/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer' as developer;

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileDataFuture;
    ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;

  @override
  void initState() {
    super.initState();
     initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _profileDataFuture = _fetchProfileData(widget.token);
  }
   @override
  void dispose() {
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
              ElevatedButton(
                child: const Text('Reload'),
                onPressed: () 
                {  setState(() {
          _profileDataFuture = _fetchProfileData(widget.token);
        });},
                // onPressed: () async {
                //   final result = await _connectivity.checkConnectivity();
                //   _updateConnectionStatus(result);
                // },
              ),
              ElevatedButton(onPressed:(){  Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);}, child:  const Text('Offline Content'),)
              
            ],
          );
        },
      );
    }
  }

  // Dismiss No Internet Dialog
  void _dismissNoInternetDialog() {
    if (isDialogOpen) {
     setState(() {
          _profileDataFuture = _fetchProfileData(widget.token);
        });
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
  }

 

  Future<Map<String, dynamic>> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
      final profilePictureUrl = profilePictureMatch?.group(1) ?? '';
      
      return {
        'studentName': data['user_info'][0]['studentname'],
        'studentEmail': data['user_info'][0]['studentemail'],
        'department': data['user_info'][0]['department'],
        'profilePictureUrl': profilePictureUrl,
        'userPoints': data['achievements'][0]['userpoints'],
        'badgesEarn': data['achievements'][0]['badgesearn'],
        'userLevel': data['achievements'][0]['userlevel'],
        'completioned': data['course_progress']['completioned'],
        'inProgress': data['course_progress']['inprogress'],
        'totalNotStarted': data['course_progress']['totalnotstarted'],
      };
    } catch (e) {
      print('Error fetching profile data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () async {
              // Navigate to the EditProfilePage and refresh data on return
              await Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(token: widget.token)));
              setState(() {
                _profileDataFuture = _fetchProfileData(widget.token);
              });
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).highlightColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingSkeleton();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading profile data'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return _buildProfileContent(data);
          } else {
            return Center(child: Text('No profile data available'));
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _profileDataFuture = _fetchProfileData(widget.token);
        });
      },
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Container(
  //color: const Color.fromARGB(255, 227, 241, 240),

  height: screenHeight * 0.23,
  width: MediaQuery.of(context).size.width * 0.83,
  
  decoration: BoxDecoration( borderRadius:
 BorderRadius.only(
    topRight: Radius.elliptical(150, 150),
    bottomLeft: Radius.circular(50),
  ),  //color: Theme.of(context).hintColor.withOpacity(0.3),
   color:Theme.of(context).cardColor,
   
          
   ),
 
  child: LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        children: [
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: constraints.maxHeight * 0.2, // Adjust radius based on available height
                backgroundImage: data['profilePictureUrl'].isNotEmpty
                    ? CachedNetworkImageProvider(data['profilePictureUrl'])
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data['studentName'],
            style: TextStyle(fontSize: constraints.maxHeight * 0.1, fontWeight: FontWeight.bold,color: Theme.of(context).highlightColor), // Adjust font size
          ),
          Text(
            data['studentEmail'],
            style: TextStyle(fontSize: constraints.maxHeight * 0.08,color: Theme.of(context).highlightColor), // Adjust font size
          ),
        ],
      );
    },
  ),
),

                    const SizedBox(height: 10),
                    RankLevel(token: widget.token),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              _buildAchievementUI(data),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildAchievementUI(Map<String, dynamic> data) {
  return Container(
     width: 370,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    // decoration: BoxDecoration(
    //   color:Theme.of(context).cardColor,
    //   borderRadius: BorderRadius.circular(20),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Theme.of(context).secondaryHeaderColor.withOpacity(0.2),
    //       spreadRadius: 1,
    //       blurRadius: 3,
    //       offset: const Offset(0, 2),
    //     ),
    //   ],
    // ),
    child: Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 2),
          decoration: BoxDecoration(
           // color: Theme.of(context).hintColor.withOpacity(0.3),
           color:Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
               Text(
                'Achievements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).highlightColor),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildAchievement(data['userPoints'], 'Points', 'assets/profileicons/Points.png'),
                  buildAchievement(data['badgesEarn'].toString(), 'Badges', 'assets/profileicons/Badges.png'),
                  buildAchievement(data['userLevel'], 'Level', 'assets/profileicons/Level.png'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Divider(
        //   height: 1,
        //   thickness: 1,
        //   color: Colors.grey[300],r
        // ),
        // const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 0),
          decoration: BoxDecoration(
           // color: Colors.grey[200],
          // color: Theme.of(context).hintColor.withOpacity(0.3),
          color:Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                 Text(
                  'Progress',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).highlightColor),
                ),
                const SizedBox(height: 10),
                buildProgressBar('Completed', data['completioned']),
                buildProgressBar('In Progress', data['inProgress']),
                buildProgressBar('Total Not Started', data['totalNotStarted']),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClayContainer(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width * 0.9,
              borderRadius: MediaQuery.of(context).size.height * 1,
              customBorderRadius: const BorderRadius.only(
                topRight: Radius.elliptical(150, 150),
                bottomLeft: Radius.circular(50),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const RankLevel(token: ''), // Placeholder widget for loading
            const SizedBox(height: 5),
            Container(
              width: 370,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Achievements',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Progress',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 400,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 400,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 400,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

