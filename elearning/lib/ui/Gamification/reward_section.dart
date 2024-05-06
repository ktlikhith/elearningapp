import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RewardSection extends StatefulWidget {
  final String token;
  final Future<RewardData> rewardDataFuture;

  RewardSection({Key? key, required this.token, required this.rewardDataFuture}) : super(key: key);

  @override
  _RewardSectionState createState() => _RewardSectionState();
}

class _RewardSectionState extends State<RewardSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RewardData>(
      future: widget.rewardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading points');
        } else {
          final _rewardData = snapshot.data;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          buildPointsCategory('Login Points', FontAwesomeIcons.laptopMedical, _rewardData?.loginPoints),
                          buildPointsCategory('Daily Quiz Points', FontAwesomeIcons.brain, _rewardData?.quizPoints),
                          buildPointsCategory('Spin Wheel Points', FontAwesomeIcons.dharmachakra, _rewardData?.spinwheelPoints),
                          buildPointsCategory('Reward Received', FontAwesomeIcons.gift, _rewardData?.rewardsReceivedPoints),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildPointsCategory(String title, IconData icon, int? points) {
    return Container(
      height: 120,
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        color: Color.fromARGB(255, 255, 252, 252),
        border: Border.all(
          color: const Color.fromARGB(255, 227, 236, 227), // Green border color
          width: 2.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: Color.fromARGB(255, 10, 10, 10)),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Color.fromARGB(255, 9, 9, 9), fontSize: 15),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Limiting to 2 lines to prevent overflow
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: SizedBox(height: 4),
                  ),
                  Text(
                    points?.toString() ?? '0', // Replace with actual point value
                    style: TextStyle(color: Color.fromARGB(255, 5, 5, 5), fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
