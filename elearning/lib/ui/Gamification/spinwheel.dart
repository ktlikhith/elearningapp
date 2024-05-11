import 'dart:async';
import 'dart:math';

import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class SpinWheel extends StatefulWidget {
  final String token;
  final Future<RewardData> rewardDataFuture;

  const SpinWheel({Key? key, required this.token, required this.rewardDataFuture}) : super(key: key);

  @override
  _SpinWheelState createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final StreamController<int> _dividerController = StreamController<int>();
  final StreamController<double> _wheelNotifier = StreamController<double>();
  late bool spinButton = false; // Provide an initial value

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
  padding: const EdgeInsets.only(top: 10,bottom: 0),
  child: SpinningWheel(
    image: Image.asset(
      'assets/images/spinimgwebsite.png',
      // width: screenWidth * 0.4,
      // height: screenHeight * 0.4,
    ),
    width: screenWidth * 0.5,
    height: screenHeight * 0.5,
    initialSpinAngle: _generateRandomAngle(),
    spinResistance: 0.3,
    shouldStartOrStop: _wheelNotifier.stream,
    canInteractWhileSpinning: false,
    dividers: 12,
    onUpdate: _dividerController.add,
    onEnd: _dividerController.add,
    secondaryImage: Image.asset(
      'assets/images/roulette-center-300.png',
      // width: screenWidth * 0.2,
      // height: screenHeight * 0.2,
    ),
    secondaryImageHeight: screenHeight * 0.08,
    secondaryImageWidth: screenWidth * 0.15,
    secondaryImageLeft: screenWidth * 0.17,
    secondaryImageTop: screenHeight * 0.08,
  ),
),

          Padding(
            padding: const EdgeInsets.only(top: 0), // Added vertical padding
            child: Text(
              'Spin the wheel and luck your chance to get points benefit and redeem.',
              textAlign: TextAlign.center, // Center align the text
            ),
          ),
          StreamBuilder<int?>(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? RouletteScore(snapshot.data ?? 1) : Container(),
          ),
          if (spinButton != null)
            NeoPopTiltedButton(
              isFloating: true,
              onTapUp: spinButton ? () => _wheelNotifier.sink.add(_generateRandomVelocity()) : null,
              decoration: NeoPopTiltedButtonDecoration(
                color: Colors.orange,
                plunkColor: Colors.orange,
                shadowColor: Color.fromRGBO(181, 177, 177, 1),
                showShimmer: true,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Text('SPIN'),
              ),
            )
          else
            CircularProgressIndicator(), // Show loading indicator if spinButton is not yet fetched
        ],
      ),
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;
  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;

  const RouletteScore(this.selected);

  final Map<int, String> labels = const {
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

  @override
  Widget build(BuildContext context) {
    return Text(
      '${labels[selected]}',
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0),
    );
  }
}
