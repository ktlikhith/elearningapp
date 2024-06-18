import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elearning/services/reward_service.dart';

class RankLevel extends StatelessWidget {
  final String token;

  const RankLevel({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          mailid = rewardData.email;
          department = rewardData.department;
          currentRank = rewardData.myRank.toString();
          nextLevel = rewardData.nextLevel.toString();
          pointsToNextLevel = rewardData.pointsNeeded.toString();
          courseAverage = rewardData.gradeNeeded.toString();
        }

        return Container(
           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          // decoration: BoxDecoration(
          //   color: Colors.grey[200],
          //   borderRadius: BorderRadius.circular(10), // Adjusted for consistency
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildRow('Mail ID', mailid, 'assets/profilesvg/gmail-svgrepo-com.svg'),
              _buildRow('Department', department, 'assets/profileicons/Department.png'),
              _buildRow('Current Level', currentRank, 'assets/profileicons/Current Level.png'),
              _buildRow('Next Level', nextLevel, 'assets/profileicons/Next Level.png'),
              _buildRow('Points to Next Level', pointsToNextLevel, 'assets/profileicons/Points to Next Level.png'),
              _buildRow('Course Average % for Next Level', courseAverage, 'assets/profileicons/Course Average.png'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Adjusted padding for better spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 30, // Adjust size based on your icon size
                height: 30,
                child: Image.asset(iconPath),
              ),
              SizedBox(width: 15), // Adjusted for better spacing
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.7, // Increased font size for better readability
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16, // Increased font size for better readability
                color: Colors.black, // Ensured text color for visibility
              ),
            ),
          ),
        ],
      ),
    );
  }
}
