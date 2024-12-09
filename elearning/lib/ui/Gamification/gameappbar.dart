import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/providers/Reward_data_provider.dart';
import 'package:elearning/services/reward_service.dart';


import 'package:flutter/material.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/Gamification/reward_section.dart';
import 'package:elearning/ui/Gamification/leaderboard.dart';
import 'package:elearning/ui/Gamification/scratchscreen.dart';
import 'package:elearning/ui/Gamification/spinwheel.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GamificationPage extends StatefulWidget {
  final String token;

  GamificationPage({Key? key, required this.token}) : super(key: key);

  @override
  _GamificationPageState createState() => _GamificationPageState();
}
// Import the RankLevel widget


class _GamificationPageState extends State<GamificationPage> {
  late Stream<RewardData> _rewardDataFuture;
 // final GlobalKey<LeaderboardState> _spinWheelKey = GlobalKey<LeaderboardState>();
   ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;
 // late Stream<RewardData> datas;
  late Stream<RewardData> datas;
  final rd=RewardService();
  final _rewardStreamController = StreamController<Stream<RewardData>>.broadcast();
  
  //final stream_data =_rewardStreamController.stream.asBroadcastStream();
  

  @override
  void initState() {
    super.initState();
    
    _rewardDataFuture = rd.getUserRewardPoints(widget.token);
    // _rewardStreamController.sink.add(_rewardDataFuture);
    // datas= _rewardDataFuture.asBroadcast();
     datas=_rewardDataFuture.asBroadcastStream();
      initConnectivity();
            

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  
   SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
     
  }
  @override
  void dispose() {
      _connectivitySubscription.cancel();
    // Revert back to the default orientation when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                onPressed:_refresh ,
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
      _refresh();
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
  }
  Future<void> _refresh()async{
    
    context.read<RewardProvider>().fetchRewardPoints();
              context.read<RewardProvider>().fetchSpinWheelData();
    // datas=_rewardDataFuture.asBroadcastStream();
  
    // _spinWheelKey.currentState?.refresh();
    // setState(() {
      
    //      _rewardDataFuture = rd.streamreward(widget.token);
    //        datas=_rewardDataFuture.asBroadcastStream();
    // });
     
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
          toolbarHeight: 65,
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 0),
            child: Image.asset('assets/gamificatinn/crown.png',),
          ),
          leadingWidth: 40,
          title: Consumer<RewardProvider>(
          builder: (context, rewardProvider, child) {
            String pointsText = 'My Points : -';
            if (rewardProvider.isLoading) {
              pointsText = 'Loading Points...';
            } else if (rewardProvider.errorMessage != null) {
              pointsText = 'Error loading points';
            } else if (rewardProvider.rewardData != null) {
              pointsText = 'My Points : ${rewardProvider.rewardData?.totalPoints}';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.5),
                  child: Text(
                    pointsText,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
       
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              child: Column(
                children: [
                 
                  RewardSection(),
                 
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 400,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: SpinWheel(token: widget.token, width: MediaQuery.of(context).size.width * 0.12,onRefresh: _refresh, rewardStreame: datas,),
                        ),
                        SizedBox(height: 20),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           Navigator.of(context).pushReplacementNamed(RouterManger.Quiz,arguments: widget.token);
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //   backgroundColor: Theme.of(context).secondaryHeaderColor,
                  // ),
                  //         child: Text('QUIZ',style: TextStyle(color: Colors.white),),
                  //       ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ScratchCardScreen(token: widget.token, onRefresh: _refresh),
                  SizedBox(height: 20),
                  
                    
                     Leaderboard(token: widget.token),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 3, token: widget.token),
      ),
    );
  }
}
