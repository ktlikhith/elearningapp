import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SVG package
import 'package:elearning/services/reward_service.dart';

class RankLevel extends StatelessWidget {
  final String token;

  const RankLevel({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 600 ? 24.0 : 40.0; // Adjust icon size based on screen width

    return FutureBuilder<RewardData>(
      future: RewardService().getUserRewardPoints(token),
      builder: (context, AsyncSnapshot<RewardData> snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        String department = '-';
        String currentRank = '-';
        String nextLevel = '-';
        String pointsToNextLevel = '-';
        String courseAverage = '-';
        String mailid = '-';

        if (snapshot.hasData) {
          final rewardData = snapshot.data!;
          mailid=rewardData.email;
          department = rewardData.department;
          currentRank = rewardData.myRank.toString();
          nextLevel = rewardData.nextLevel.toString();
          pointsToNextLevel = rewardData.pointsNeeded.toString();
          courseAverage = rewardData.gradeNeeded.toString();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildRow('Mail ID', mailid, 'assets/profilesvg/gmail-svgrepo-com.svg', iconSize),
              _buildRow('Department', department, 'assets/profilesvg/open-an-account-svgrepo-com.svg', iconSize),
              _buildRow('Current Level', currentRank, 'assets/profilesvg/verified-svgrepo-com.svg', iconSize),
              _buildRow('Next Level', nextLevel, 'assets/profilesvg/vip-svgrepo-com.svg', iconSize),
              _buildRow('Points to Next Level', pointsToNextLevel, 'assets/profilesvg/market-analysis-svgrepo-com.svg', iconSize),
              _buildRow('Course Average % for Next Level', courseAverage, 'assets/profilesvg/risk-assessment-svgrepo-com.svg', iconSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value, String iconPath, double iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: iconSize, // Adjust size based on your icon size
                height: iconSize,
                child: SvgPicture.asset(iconPath),
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
              ),
            ],
          ),
          Text(
            value,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
