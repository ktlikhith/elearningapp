

// import 'dart:async';
// import 'dart:math';

// import 'package:clay_containers/widgets/clay_container.dart';
// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/gamepoints_service.dart';
// import 'package:elearning/services/reward_service.dart';
// import 'package:flutter/material.dart';
// import 'package:kbspinningwheel/kbspinningwheel.dart';
// import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

// class SpinWheel extends StatefulWidget {
//   final String token;
//   final Future<RewardData> rewardDataFuture;
//   final double width;

//   const SpinWheel({
//     Key? key,
//     required this.token,
//     required this.rewardDataFuture,
//     required this.width,
//   }) : super(key: key);

//   @override
//   _SpinWheelState createState() => _SpinWheelState();
// }

// class _SpinWheelState extends State<SpinWheel> {
//   final StreamController<int> _dividerController = StreamController<int>();
//   final StreamController<double> _wheelNotifier = StreamController<double>();
//   late bool spinButton = false;
//   String selectedLabel = '';

//   @override
//   void initState() {
//     super.initState();
//     widget.rewardDataFuture.then((rewardData) {
//       setState(() {
//         spinButton = rewardData.spinButton;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _dividerController.close();
//     _wheelNotifier.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//      width: widget.width,
          
//           decoration: BoxDecoration( 
//             //color:Theme.of(context).cardColor,
//              gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF3ACBE8), // Start color with opacity
//                           Color(0xFF0D85D8), // Mid color with opacity
//                           Color(0xFF0041C7), // End color with opacity
//                         ],
                     
//                       ),
//             borderRadius: BorderRadius.circular(30.0),
//            // image:Image.asset('assets/images/bg.jpg',fit: BoxFit.fill,),
//             boxShadow: [
//               BoxShadow(
//                color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 0,
//                 blurRadius: 2,
//                 offset: Offset(0, 2),
//               ),
//             ],
//             ),

//           // height: MediaQuery.of(context).size.height*0.23,
//           // width: MediaQuery.of(context).size.width*0.9,
//           //borderRadius: MediaQuery.of(context).size.width*.1,
//     // Container(
//       // width: widget.width,
//       // padding: const EdgeInsets.all(10),
//       // decoration: BoxDecoration(
//       //   color: Colors.white,
//       //   borderRadius: BorderRadius.circular(20),
//       //   border: Border.all(
//       //       color: Colors.grey[300]!,
//       //       width: 2.0,
//       //     ),
        
        
//       //   boxShadow: [
//       //     BoxShadow(
//       //       color:Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
//       //       spreadRadius: 2,
//       //       blurRadius: 4,
//       //       offset: Offset(2, 6),
            
//       //     ),
//       //   ],
//       // ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 2.5, bottom: 0),
//             child: IgnorePointer( 
//               child:SpinningWheel(
//               image: Image.asset(
//                 'assets/images/spinimgwebsite.png',
//               ),
//               width: widget.width * 3.5,
//               height: widget.width * 3.5,
//               initialSpinAngle: 0.0,
//               spinResistance: 0.3,
//               shouldStartOrStop: _wheelNotifier.stream,
//               canInteractWhileSpinning: false, // Disable interaction while spinning
//               dividers: 12,
//               onUpdate: _dividerController.add,
//               onEnd: (int selected) {
//                 setState(() {
//                   selectedLabel = _getLabel(selected);
//                 });
                
//                 _addRewardPoints(selectedLabel);
//               },
//               // secondaryImage: Image.asset(
//               //   'assets/images/belt.png',
//               // ),
//               // secondaryImageHeight: widget.width * 3.5,
//               // secondaryImageWidth: widget.width * 3.5,
//               // secondaryImageLeft: widget.width * 0.0,
//               // secondaryImageTop: widget.width * 0.0,
             
 
//             )
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 spinButton?
//                 'Spin the wheel and luck your chance to get points benefit and redeem.':'You have won todays luck on wheel, try next day',
//                 textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Theme.of(context).highlightColor), 
//               ),
//             ),
//           ),
//           StreamBuilder<int?>(
//             stream: _dividerController.stream,
//             builder: (context, snapshot) =>
//                 snapshot.hasData ? rouletteScore(snapshot.data!) : Container(),
//           ),
//           if (spinButton != null)
//             NeoPopTiltedButton(
//               isFloating: true,
//               onTapUp: spinButton
//                   ? () {
//                       _wheelNotifier.sink.add(_generateRandomVelocity());
//                     }
//                   : null, // Disable onTapUp when spinButton is false
//               decoration: NeoPopTiltedButtonDecoration(
//                 color: Theme.of(context).hintColor,
//                 plunkColor: Theme.of(context).hintColor,
//                // shadowColor: Theme.of(context).primaryColor,
//                 showShimmer: true,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
//                 child: Text('SPIN' , style: TextStyle(color: Theme.of(context).highlightColor),),
//               ),
//             )
//           else
//             CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }

//   Widget rouletteScore(int selected) {
//     final String label = _getLabel(selected);
//     return Text(spinButton?
//       label:'',
//       style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0,color: Theme.of(context).highlightColor),
//     );
//   }

//   String _getLabel(int selected) {
//     final Map<int, String> labels = {
//       1: '17',
//       2: '00',
//       3: '21',
//       4: '30',
//       5: '50',
//       6: '00',
//       7: '5',
//       8: '7',
//       9: '5',
//       10: '9',
//       11: '13',
//       12: '5',
//     };
//     return labels[selected] ?? '';
//   }

//   Future<void> _addRewardPoints(String label) async {
    
    
//     try {
//       final response = await RewardPointService().addReward(
//         token: widget.token,
//         type: 'spinwheel',
//         points: label,
//       );
//       // Show the popup dialog after successfully adding the reward points
//       _showCongratsDialog(label);
//     } catch (e) {
//       print('Error adding reward points: $e');
//     }
    

//   }

//   void _showCongratsDialog(String label) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Congratulations!',),
//           content: Text('You won spin wheel points: $label'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }



//   double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;
//   double _generateRandomAngle() => Random().nextDouble() * pi * 2;
// }

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:confetti/confetti.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/gamepoints_service.dart';
import 'package:elearning/services/reward_service.dart';
import 'package:elearning/ui/Gamification/gameappbar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:neopop/neopop.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SpinWheel extends StatefulWidget {
  final String token;
 late Stream<RewardData> rewardStreame;
  final double width;
    final Function onRefresh; // Accept a callback from the parent
  
 

   SpinWheel({
    Key? key,
    required this.token,
   required this.rewardStreame,
    required this.width,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _SpinWheelState createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final StreamController<int> _dividerController = StreamController<int>();
  final StreamController<double> _wheelNotifier = StreamController<double>();
 bool spinButton = false;
  bool isLoading=true;
    late Stream<spinwheel> _rewardDataFuture;
  String selectedLabel = '';
  bool isconfettiplaying=false;
  final confettiController=ConfettiController();
  late Stream<spinwheel> datas;
   final rd =RewardService();
  // late RewardService rewardService;
  @override
  void initState() {
  
    super.initState();
    _rewardDataFuture=rd.getspinwheel(widget.token);
     datas=_rewardDataFuture.asBroadcastStream();
    //  load();
  
    ///listen to states: play the confitt animation
   
    confettiController.addListener((){
     setState(() {
         isconfettiplaying=confettiController.state==ConfettiControllerState.playing;  
      
    });
   
   
    });
  }
//  Future<void> load() async {
//     // Fetch the reward data from the provider
//     // final rewardProvider = Provider.of<RewardProvider>(context, listen: false);

//     try {
//       await rewardProvider.fetchRewardData(widget.token); // Token from the parent widget

//       // Check if data is successfully fetched
//       if (rewardProvider.rewardData != null) {
//         setState(() {
//           spinButton = rewardProvider.rewardData!.spinButton; // Update the state
//         });
//       }
//     } catch (e) {
//       // Handle error if needed
//       print('Error loading data: $e');
//     } finally {
//       // After the data is fetched, stop showing the loading indicator
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
   void refresh() async{
    // setState(() {
    //     final _rewardDataFuture=rd.getUserRewardPoints(widget.token);
    //  datas=_rewardDataFuture.asBroadcastStream();
    // });
      
       await  widget.onRefresh();
      
    }

  @override
  void dispose() {
    _dividerController.close();
    _wheelNotifier.close();
    

    super.dispose();
  }
   Widget _buildShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: widget.width,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).secondaryHeaderColor,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
 


  @override
  Widget build(BuildContext context) {
 
    
      // final rewardProvider = Provider.of<RewardProvider>(context,listen: false);
      
           
 

   
        
    return
     StreamBuilder<spinwheel>(

        stream:_rewardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerItem(context);
          } else if (snapshot.hasError) {
            return  _buildShimmerItem(context);
          
          } else {
            final rewardData = snapshot.data!;
    
    
    
     
   return Container(
      width: widget.width,
      decoration: BoxDecoration(
     color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
            
              IgnorePointer(
                child: SpinningWheel(
                  image: Image.asset(
                    'assets/images/spinimgwebsite.png',
                    width: widget.width * 3.45,
                    height: widget.width*3.43,
                  ),
                  width: widget.width * 3.55,
                  height: widget.width * 3.5,
                  initialSpinAngle: 0.0,
                  spinResistance: 0.3,
                  shouldStartOrStop: _wheelNotifier.stream,
                  canInteractWhileSpinning: false,
                  dividers: 12,
                  onUpdate: _dividerController.add,
                  onEnd: (int selected) {
                    setState(() {
                      selectedLabel = _getLabel(selected);
                    });
                    _addRewardPoints(selectedLabel);
                  },
                ),
              ),
              Positioned(
                width: widget.width * 3.7,
                height: widget.width * 3.8,
                bottom: 0.15,
                //left: 0.5,
                right: 0.1,
              //top:  0.00005,
               child:  Image.asset(
              
                'assets/images/belt.png',
                width: widget.width * 4.3, // Adjust width as needed
                height: widget.width * 3.9, // Adjust height as needed
              ),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                
                rewardData.spinButton
                    ? 'Spin the wheel and try your luck to get points benefit and redeem.'
                    : 'You have won todays luck on wheel, try next day',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ),
              ),
            ),
          ),
          StreamBuilder<int?>(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? rouletteScore(snapshot.data!) : Container(),
          ),

     rewardData.spinButton?
            NeoPopTiltedButton(
              isFloating: true,
              onTapUp:  rewardData.spinButton
                  ? () {
                      _wheelNotifier.sink.add(_generateRandomVelocity());
                    }
                  : null,
              decoration: NeoPopTiltedButtonDecoration(
                color: Theme.of(context).hintColor,
                plunkColor: Theme.of(context).hintColor,
                showShimmer: true,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Text(
                  'SPIN',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ):Container(),
          // else
          //   CircularProgressIndicator(),
        ],
      ),
    );
          }
        }
    );
  }

  Widget rouletteScore(int selected) {
    final String label = _getLabel(selected);
    return Text(
      spinButton ? label : '',
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 24.0,
        color: Theme.of(context).highlightColor,
      ),
    );
  }

  String _getLabel(int selected) {
    final Map<int, String> labels = {
      1: '17',
      2: '00',
      3: '21',
      4: '30',
      5: '50',
      6: '00',
      7: '5',
      8: '7',
      9: '5',
      10: '9',
      11: '13',
      12: '5',
    };
    return labels[selected] ?? '';
  }

  Future<void> _addRewardPoints(String label) async {
    try {
        label=='00'?showMotivationalDialog(context,refresh):_showCongratsDialog(label,refresh);
      if(!isconfettiplaying){
        confettiController.play();
        Future.delayed(Duration(seconds: 5),(){
             confettiController.stop();

        });
      }
      final response = await RewardPointService().addReward(
        token: widget.token,
        type: 'spinwheel',
        points: label,
      );
      
    
    } catch (e) {
      print('Error adding reward points: $e');
    }
  }

  // void _showCongratsDialog(String label) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //  shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //         title:  Row(
  //         children: [
  //           Icon(Icons.celebration, color: Colors.green,size: 40,),
  //           SizedBox(width: 10),
  //           Text('Congratulations!'),
  //         ],
  //       ),
  //         content: Text('You won spin wheel points: $label'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pushReplacementNamed(
  //                 RouterManger.Gamification,
  //                 arguments: widget.token,
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
void _showCongratsDialog(String label,Function refresh) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows tapping outside the dialog to dismiss it
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
              await refresh();
              //load();
          if(isconfettiplaying){
            confettiController.stop();
          }
         
              Navigator.of(context).pop();      // Perform the navigation action when the back button is pressed
         
          return true;
        },
        child: GestureDetector(
          
          onTap: ()async {
             await refresh();
            // load();
             if(isconfettiplaying){
            confettiController.stop();
          }  
           
            Navigator.of(context).pop();
          
           
        
          },
          child: Column(
              children: [
            Stack(
                    children: [
          
              
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: EdgeInsets.zero, // To remove the default padding
                  content: 
                      
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF3ACBE8),
                              Color(0xFF0D85D8),
                              Color(0xFF0041C7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.all(20.0), // Adjust padding as needed
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          //   SizedBox(height: 10),
                          //   Center(
                          //  child: ConfettiWidget(
                          //            confettiController: confettiController,
                          //            shouldLoop: true,
                          //            blastDirectionality: BlastDirectionality.explosive,
                          //           // blastDirection: -pi / 2,//blast all the direction
                          //            numberOfParticles: 20,
                          //            emissionFrequency: 0.10,
                          //            minBlastForce: 10,
                          //            maxBlastForce: 50,
                          //            gravity: 1.0,
                          //            colors: [
                          //              Color.fromARGB(255, 249, 2, 2),
                          //              Color.fromARGB(255, 238, 85, 3),
                          //              Color.fromARGB(255, 240, 244, 11),
                          //              Color.fromARGB(255, 99, 245, 8),
                          //              Color.fromARGB(255, 9, 222, 212),
                          //              Color.fromARGB(255, 34, 7, 241),
                          //              Color.fromARGB(255, 241, 9, 241),
                                       
                          //            ],
                          //          ),
                        //  ),
                            Row(
                              children: [
                                
                                Icon(Icons.celebration, color: Color.fromARGB(255, 13, 10, 221), size: 40),
                                SizedBox(width: 5),
                                AnimatedTextKit(
                                  animatedTexts: [
                                    FadeAnimatedText(
                                      'Congratulations!',
                                      textStyle: GoogleFonts.lato(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                  ],
                                  isRepeatingAnimation: true,
                                  displayFullTextOnTap: true,
                                  stopPauseOnTap: true,
                                  repeatForever: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              'You won spin wheel points:',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  label,
                                  textStyle: TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  colors: [
                                    Color.fromARGB(255, 242, 244, 244),
                                    Color.fromARGB(255, 16, 13, 216),
                                    Color.fromARGB(255, 0, 10, 199),
                                  ],
                                  textDirection: TextDirection.ltr,
                                  speed: Duration(milliseconds: 1000),
                                ),
                              ],
                              isRepeatingAnimation: true,
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                              repeatForever: true,
                            ),
                             
                          ],
                        ),
                        
                      ),
                  
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(right:MediaQuery.of(context).size.width*1),
                    child: ConfettiWidget(
                                         confettiController: confettiController,
                                         shouldLoop: false,
                                         blastDirectionality: BlastDirectionality.explosive,
                                        // blastDirection: -pi / 2,//blast all the direction
                                         numberOfParticles: 15,
                                         emissionFrequency: 0.15,
                                         minBlastForce: 10,
                                         maxBlastForce: 35,
                                         gravity: 1.0,
                                         colors: [
                                           Color.fromARGB(255, 249, 2, 2),
                                           Color.fromARGB(255, 238, 85, 3),
                                           Color.fromARGB(255, 240, 244, 11),
                                           Color.fromARGB(255, 99, 245, 8),
                                           Color.fromARGB(255, 9, 222, 212),
                                           Color.fromARGB(255, 34, 7, 241),
                                           Color.fromARGB(255, 241, 9, 241),
                                           
                                         ],
                                       ),
                  ),
                                     Padding(
                                       padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width*1),
                                       child: ConfettiWidget(
                                         confettiController: confettiController,
                                         shouldLoop: false,
                                         blastDirectionality: BlastDirectionality.explosive,
                                        // blastDirection: -pi / 2,//blast all the direction
                                         numberOfParticles: 15,
                                         emissionFrequency: 0.15,
                                         minBlastForce: 10,
                                         maxBlastForce: 35,
                                         gravity: 1.0,
                                         colors: [
                                           Color.fromARGB(255, 249, 2, 2),
                                           Color.fromARGB(255, 238, 85, 3),
                                           Color.fromARGB(255, 240, 244, 11),
                                           Color.fromARGB(255, 99, 245, 8),
                                           Color.fromARGB(255, 9, 222, 212),
                                           Color.fromARGB(255, 34, 7, 241),
                                           Color.fromARGB(255, 241, 9, 241),
                                           
                                         ],
                                       ),
                                     ),
                ],
              ),
          
             
                             
                    
                    ],
                   
                  ),
            ],

          ),
          
        ),
     
      );
    },
  );
}


void showMotivationalDialog(BuildContext context,Function refresh) {
  showDialog(
    context: context,
     barrierDismissible: true,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
              await refresh();
             // load();
          if(isconfettiplaying){
            confettiController.stop();
          }   
         
              Navigator.of(context).pop();      // Perform the navigation action when the back button is pressed
          
          return true;
        },
        child:AlertDialog(
          backgroundColor: Color.fromARGB(127, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Better Luck Next Time!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/gamificatinn/genaimg.webp', // Path to your GIF
                height: 150.0,
                width: 150.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Keep spinning daily for more chances!",
              style: TextStyle(
                 color: Colors.white,
                fontSize: 20.0,
                 fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("OK",style: TextStyle(color: Colors.white),),
            onPressed: () async{
              await refresh();
              Navigator.of(context).pop();
            },
          ),
        ],
        ),
      );
    },
  );
}




  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;
  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}
