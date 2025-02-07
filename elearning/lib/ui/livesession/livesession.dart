import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/live_event_service.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:elearning/ui/Webview/testweb.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class LiveSessionPage extends StatefulWidget {
  final String token;

  const LiveSessionPage({Key? key, required this.token}) : super(key: key);

  @override
  _LiveSessionPageState createState() => _LiveSessionPageState();
}

class _LiveSessionPageState extends State<LiveSessionPage> {
  late Future<List<LiveSession>> _futureData;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;
  @override
  void initState() {
    super.initState();
    _fetchLiveEventData();
       initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  @override
  void dispose(){
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
                onPressed:_fetchLiveEventData ,
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
      _fetchLiveEventData();
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
  }

  Future<void> _fetchLiveEventData() async {
    setState(() {
      _futureData = LiveSessionService().fetchLiveSessions(widget.token);
    });
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: 4, // Adjust the number of shimmer items as needed
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150, // Adjust the height of the shimmer image placeholder
                  color: Colors.grey[300],
                ),
                SizedBox(height: 12),
                Container(
                  width: 200, // Adjust the width of the text shimmer placeholder
                  height: 22,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 8),
                Container(
                  width: 150, // Adjust the width of the text shimmer placeholder
                  height: 22,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Live Event',
          ),
          centerTitle: false,
           leading: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 0),
            child: SvgPicture.asset('assets/appbarsvg/world-internet-svgrepo-com.svg'),
          ),
          leadingWidth: 48,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder<List<LiveSession>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerEffect(); // Show shimmer effect while loading
            } else if (snapshot.hasError) {
              return Center(child: Text('something went wrong'));//Error: ${snapshot.error}
            } else if (snapshot.hasData) {
              final List<LiveSession> sessions = snapshot.data!;
              if (sessions.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                return RefreshIndicator(
                  onRefresh: ()async{
                    setState(() {
                      _fetchLiveEventData();
                    });

                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: Container(
                         // padding: const EdgeInsets.symmetric(vertical:20),
                          decoration: BoxDecoration(
                             color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12.0), // Set border radius
                            border: Border.all(color: Color.fromARGB(255, 173, 172, 172)!), // Set border color
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                         
                              Container(
                                 
                                width: double.infinity,
                                    child:ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                child: Image.network(
                                  sessions[index].imgUrl,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                              ),
                              SizedBox(height: 4),
                              ListTile(
                                title: Text(
                                  sessions[index].activityName,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).highlightColor),
                                ),
                               subtitle: Text.rich(
                          TextSpan(
                            children: [
                               TextSpan(
                                text: 'Speaker: ',style: TextStyle(color:Color.fromARGB(255, 52, 236, 208),fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: ' ${sessions[index].username}\n',
                                style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
                              ),
                               TextSpan(
                                text: 'Start Time: ',style: TextStyle(color:Color.fromARGB(255, 52, 236, 208) ,fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${sessions[index].startTime}\n',
                                style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
                              ),
                               TextSpan(
                                text: 'Mode: ',style: TextStyle(color: Color.fromARGB(255, 52, 236, 208),fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: '${sessions[index].sessionMod}',
                                style: TextStyle(color: Theme.of(context).highlightColor,fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        
                              ),
                              SizedBox(height: 2),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    if (sessions[index].url != null && sessions[index].url.isNotEmpty) {
                                      String moduleUrl = sessions[index].url;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewPage('Live Event', moduleUrl,widget.token),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    
                                    mainAxisSize: MainAxisSize.min, // Ensure the row takes only the minimum required space
                                    children: [
                                     Icon(
                                         sessions[index].sessionMod=='Online'?FontAwesomeIcons.play:FontAwesomeIcons.signIn,
                                        color: Theme.of(context).highlightColor,
                                      ), // Add the Font Awesome icon
                                      SizedBox(width: 8), // Add some space between the icon and text
                                      Text(
                                        sessions[index].sessionMod=='Online'?'Join Now':'Sign Up',
                                        style: TextStyle(color:  Theme.of(context).highlightColor,),
                                      ),
                                    ],
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Theme.of(context).canvasColor, 
                                    // Set button background color
                                  ),
                                ),
                                
                              ),
                              SizedBox(height: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
        
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 2, token: widget.token),
      ),
      
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
