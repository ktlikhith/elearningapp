

import 'dart:async';
import 'dart:math';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/gamepoints_service.dart';
import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class SpinWheel extends StatefulWidget {
  final String token;
  final Future<RewardData> rewardDataFuture;
  final double width;

  const SpinWheel({
    Key? key,
    required this.token,
    required this.rewardDataFuture,
    required this.width,
  }) : super(key: key);

  @override
  _SpinWheelState createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final StreamController<int> _dividerController = StreamController<int>();
  final StreamController<double> _wheelNotifier = StreamController<double>();
  late bool spinButton = false;
  String selectedLabel = '';

  @override
  void initState() {
    super.initState();
    widget.rewardDataFuture.then((rewardData) {
      setState(() {
        spinButton = rewardData.spinButton;
      });
    });
  }

  @override
  void dispose() {
    _dividerController.close();
    _wheelNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  ClayContainer(
     width: widget.width,
          color: Color.fromARGB(255, 234, 246, 246),

          // height: MediaQuery.of(context).size.height*0.23,
          // width: MediaQuery.of(context).size.width*0.9,
          borderRadius: MediaQuery.of(context).size.width*.1,
    // Container(
      // width: widget.width,
      // padding: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(20),
      //   border: Border.all(
      //       color: Colors.grey[300]!,
      //       width: 2.0,
      //     ),
        
        
      //   boxShadow: [
      //     BoxShadow(
      //       color:Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
      //       spreadRadius: 2,
      //       blurRadius: 4,
      //       offset: Offset(2, 6),
            
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.5, bottom: 0),
            child: IgnorePointer( 
              child:SpinningWheel(
              image: Image.asset(
                'assets/images/spinimgwebsite.png',
              ),
              width: widget.width * 3.5,
              height: widget.width * 3.5,
              initialSpinAngle: 0.0,
              spinResistance: 0.3,
              shouldStartOrStop: _wheelNotifier.stream,
              canInteractWhileSpinning: false, // Disable interaction while spinning
              dividers: 12,
              onUpdate: _dividerController.add,
              onEnd: (int selected) {
                setState(() {
                  selectedLabel = _getLabel(selected);
                });
                
                _addRewardPoints(selectedLabel);
              },
              // secondaryImage: Image.asset(
              //   'assets/images/roulette-center-300.png',
              // ),
              // secondaryImageHeight: widget.width * 1,
              // secondaryImageWidth: widget.width * 1,
              // secondaryImageLeft: widget.width * 1.3,
              // secondaryImageTop: widget.width * 1.1,
             
 
            )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                spinButton?
                'Spin the wheel and luck your chance to get points benefit and redeem.':'You have won todays luck on wheel, try next day',
                textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold), 
              ),
            ),
          ),
          StreamBuilder<int?>(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? rouletteScore(snapshot.data!) : Container(),
          ),
          if (spinButton != null)
            NeoPopTiltedButton(
              isFloating: true,
              onTapUp: spinButton
                  ? () {
                      _wheelNotifier.sink.add(_generateRandomVelocity());
                    }
                  : null, // Disable onTapUp when spinButton is false
              decoration: NeoPopTiltedButtonDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                plunkColor: Theme.of(context).secondaryHeaderColor,
                shadowColor: Color.fromRGBO(181, 177, 177, 1),
                showShimmer: true,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Text('SPIN'),
              ),
            )
          else
            CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget rouletteScore(int selected) {
    final String label = _getLabel(selected);
    return Text(spinButton?
      label:'',
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0),
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
    print("Adding reward points: $label");
    print(spinButton);
    
    try {
      final response = await RewardPointService().addReward(
        token: widget.token,
        type: 'spinwheel',
        points: label,
      );
      // Show the popup dialog after successfully adding the reward points
      _showCongratsDialog(label);
    } catch (e) {
      print('Error adding reward points: $e');
    }
    

  }

  void _showCongratsDialog(String label) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!',),
          content: Text('You won spin wheel points: $label'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
               Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
              },
            ),
          ],
        );
      },
    );
  }



  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;
  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

