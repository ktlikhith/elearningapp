import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'gameappbar.dart';

class SpinWheel1 extends StatefulWidget {
  @override
  _SpinWheel1State createState() => _SpinWheel1State();
}

class _SpinWheel1State extends State<SpinWheel1> {
  final StreamController<int> _dividerController = StreamController<int>();

  @override
  void dispose() {
    _dividerController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinningWheel(
            image: Image.asset('assets/images/roulette-8-300.png'),
            width: 310,
            height: 310,
            initialSpinAngle: _generateRandomAngle(),
            spinResistance: 0.6,
            canInteractWhileSpinning: false,
            dividers: 8,
            onUpdate: _dividerController.add,
            onEnd: _dividerController.add,
            secondaryImage:
                Image.asset('assets/images/roulette-center-300.png'),
            secondaryImageHeight: 60,
            secondaryImageWidth: 110,
            secondaryImageLeft:30,
            secondaryImageTop: 60,
            
          ),
          SizedBox(height: 30),
          StreamBuilder<int?>(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? RouletteScore(snapshot.data ?? 1) : Container(),
          )
        ],
      ),
    );
  }

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}



class RouletteScore extends StatelessWidget {
  final int selected;

  const RouletteScore(this.selected);

  final Map<int, String> labels = const {
    1: '1000\$',
    2: '400\$',
    3: '800\$',
    4: '7000\$',
    5: '5000\$',
    6: '300\$',
    7: '2000\$',
    8: '100\$',
  };

  @override
  Widget build(BuildContext context) {
    return Text(
      '${labels[selected]}',
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0),
    );
  }
}