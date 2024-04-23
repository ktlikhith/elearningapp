import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';


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
          Padding(
            padding: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(0.8),
              child: SpinningWheel(
                image: Image.asset('assets/images/roulette-8-300.png'),
                width: 230,
                height: 230,
                initialSpinAngle: _generateRandomAngle(),
                spinResistance: 0.8,
                canInteractWhileSpinning: false,
                dividers: 8,
                onUpdate: _dividerController.add,
                onEnd: _dividerController.add,
                secondaryImage:
                    Image.asset('assets/images/roulette-center-300.png'),
                secondaryImageHeight: 60,
                secondaryImageWidth: 110,
                secondaryImageLeft:46,
                secondaryImageTop: 68,
                
              ),
            ),
          ),
          Text('Spin the wheel and luck your chance to get points benefit and redeem.'),
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(height: 30),
          ),
          StreamBuilder<int?>(
            stream: _dividerController.stream,
            builder: (context, snapshot) =>
                snapshot.hasData ? RouletteScore(snapshot.data ?? 1) : Container(),
                
          ),
           NeoPopTiltedButton(
  isFloating: true,
  onTapUp: () {},
  decoration: NeoPopTiltedButtonDecoration(
    color:Color(0xFFD500F9),
    plunkColor: Color(0xFFD500F9),
    shadowColor: Color.fromRGBO(181, 177, 177, 1),
    showShimmer: true,

 
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
    child: Text('SPIN'),
  ),
),
          
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