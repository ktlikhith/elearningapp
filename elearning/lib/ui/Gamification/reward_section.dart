import 'package:elearning/providers/Reward_data_provider.dart';
import 'package:elearning/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

class RewardSection extends StatefulWidget {
 

  RewardSection({Key? key, }) : super(key: key);

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
    // Trigger data fetching when this widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RewardProvider>(context, listen: false).fetchRewardPoints();
    });

    return Consumer<RewardProvider>(
      builder: (context, rewardProvider, child) {
        if (rewardProvider.isLoading) {
          return _buildShimmerSkeleton();
        } else if (rewardProvider.errorMessage != null) {
          return _buildDefaultPointsCategories();
        } else if (rewardProvider.rewardData != null) {
          final _rewardData = rewardProvider.rewardData;
          return _buildRewardPointsCategories(_rewardData);
        } else {
          return _buildDefaultPointsCategories(); // Fallback if no data is available.
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
          height: 80,
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
              boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(color: Theme.of(context).primaryColor,),
            color: Theme.of(context).hintColor.withOpacity(0.1),
          ),
          child: Stack(
            children:[ Padding(
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
                    style:  TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color:Colors.grey[600],
                    ),
                  ),
                ],
              
            ),
          
        ),
        Positioned(
          right: -10,
          top: -15,
          bottom: 0,
          child: Align(
            alignment: Alignment.centerRight,
               child: Stack(
                children: [
                  Positioned(
                    right: 18,
                    top: 22,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                         boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ), Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                 boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                  ),
                ],
                color: Theme.of(context).hintColor.withOpacity(0.2),
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
                       boxShadow: [
                  
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(4, 4),
                            blurRadius: 6,
                          ),
                        
                ],
                    color: Theme.of(context).cardColor,
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
                ],
               ),
          ),
        ),
            ]
          ),
        ),
          Container(
          width: 220,
          height: 80,
          padding: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(
              color: Theme.of(context).cardColor,
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
