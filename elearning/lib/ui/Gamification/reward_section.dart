import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

class RewardSection extends StatefulWidget {
  final String token;
  final Future<RewardData> rewardDataFuture;

  RewardSection({Key? key, required this.token, required this.rewardDataFuture}) : super(key: key);

  @override
  _RewardSectionState createState() => _RewardSectionState();
}

class _RewardSectionState extends State<RewardSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          _scrollController.animateTo(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        } else {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RewardData>(
      future: widget.rewardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerSkeleton();
        } else if (snapshot.hasError) {
          return _buildDefaultPointsCategories();
        } else {
          final _rewardData = snapshot.data;
          return _buildRewardPointsCategories(_rewardData);
        }
      },
    );
  }

  Widget _buildDefaultPointsCategories() {
    return _buildPointsCategories(
      loginPoints: '0',
      quizPoints: '0',
      spinwheelPoints: '0',
      rewardsReceivedPoints: '0',
    );
  }

  Widget _buildRewardPointsCategories(RewardData? rewardData) {
    return _buildPointsCategories(
      loginPoints: rewardData?.loginPoints?.toString() ?? '0',
      quizPoints: rewardData?.quizPoints?.toString() ?? '0',
      spinwheelPoints: rewardData?.spinwheelPoints?.toString() ?? '0',
      rewardsReceivedPoints: rewardData?.rewardsReceivedPoints?.toString() ?? '0',
    );
  }

Widget _buildPointsCategories({
  required String loginPoints,
  required String quizPoints,
  required String spinwheelPoints,
  required String rewardsReceivedPoints,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          buildPointsCategory(context, 'Login Points', FontAwesomeIcons.laptopMedical, loginPoints, Color.fromARGB(255, 49, 205, 54)),
          buildPointsCategory(context, 'Daily Quiz Points', FontAwesomeIcons.brain, quizPoints, const Color.fromARGB(255, 32, 126, 204)),
          buildPointsCategory(context, 'Spin Wheel Points', FontAwesomeIcons.dharmachakra, spinwheelPoints, const Color.fromARGB(255, 255, 0, 0)),
          buildPointsCategory(context, 'Reward Received', FontAwesomeIcons.gift, rewardsReceivedPoints, Color.fromARGB(255, 244, 54, 117)),
        ],
      ),
    ),
  );
}

Widget buildPointsCategory(BuildContext context, String title, IconData icon, String points, Color backgroundColor) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      clipBehavior: Clip.antiAlias, children: [
        Container(
          width: 220,
          height: 90,
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(color: Theme.of(context).secondaryHeaderColor.withOpacity(.4),),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: -30,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0),
                  bottomLeft: Radius.circular(45.0),
                ),
              ),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                    child: Icon(icon, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildShimmerSkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: List.generate(4, (index) => _buildShimmerItem(context)),
      ),
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 200,
          height: 100,
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
}
