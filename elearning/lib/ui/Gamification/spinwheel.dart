import 'dart:async';
import 'dart:math';

import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class SpinWheel extends StatefulWidget {
  final String token;
  final Future<RewardData> rewardDataFuture;
  final double width; // Add a width parameter

  const SpinWheel({Key? key, required this.token, required this.rewardDataFuture, required this.width}) : super(key: key);

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
  return Container(
    width: 400,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.5, bottom: 0),
          child: SpinningWheel(
            image: Image.asset(
              'assets/images/spinimgwebsite.png',
            ),
            width: widget.width * 3.5, // Adjust the width of the SpinningWheel widget
            height: widget.width * 3.5, // Adjust the height of the SpinningWheel widget
            initialSpinAngle: _generateRandomAngle(),
            spinResistance: 0.3,
            shouldStartOrStop: _wheelNotifier.stream,
            canInteractWhileSpinning: false,
            dividers: 12,
            onUpdate: _dividerController.add,
            onEnd: _dividerController.add,
            secondaryImage: Image.asset(
              'assets/images/roulette-center-300.png',
            ),
            secondaryImageHeight: widget.width * 1, // Adjust the height of the secondary image
            secondaryImageWidth: widget.width * 1, // Adjust the width of the secondary image
            secondaryImageLeft: widget.width * 1.3, // Adjust the left position of the secondary image
            secondaryImageTop: widget.width * 1.1, // Adjust the top position of the secondary image
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Spin the wheel and luck your chance to get points benefit and redeem.',
            textAlign: TextAlign.center,
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
          CircularProgressIndicator(),
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
