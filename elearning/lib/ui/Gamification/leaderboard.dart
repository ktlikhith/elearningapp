import 'package:flutter/material.dart';
import 'package:elearning/services/leaderboardservice.dart';
import 'package:shimmer/shimmer.dart';

class Leaderboard extends StatefulWidget {
  final String token;

  Leaderboard({Key? key, required this.token}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<User> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    setState(() {
      isLoading = true;
    });

    try {
      final leaderboardUsers = await LeaderboardService.fetchLeaderboard(widget.token);
      setState(() {
        users = leaderboardUsers;
      });
    } catch (e) {
      print('Error fetching leaderboard: $e');
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Leader Board', style: TextStyle(fontSize: screenSize.width * 0.05, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          isLoading
              ? _buildShimmerSkeleton(screenSize)
              : users.isNotEmpty
                  ? buildLeaderBoard(screenSize)
                  : Text(
                      'Will get back to you once Leaderboard is updated',
                      textAlign: TextAlign.center,
                    ),
        ],
      ),
    );
  }

  Widget _buildShimmerSkeleton(Size screenSize) {
    return SizedBox(
      height: screenSize.height * 0.5, // Adjust height as needed
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 5, // Adjust the number of shimmer items as needed
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLeaderBoard(Size screenSize) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.orange), // Set the color for the heading row
        columnSpacing: 20,
        columns: [
          DataColumn(
            label: Center(
              child: Text('#No', style: TextStyle(color: Colors.white)),
            ),
          ),
          DataColumn(
            label: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
                child: Text('Name', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          DataColumn(
            label: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
                child: Text('Rank', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          DataColumn(
            label: Center(
              child: Text('Points', style: TextStyle(color: Colors.white)),
            ),
          ),
          DataColumn(
            label: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
                child: Text('Department', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
        rows: users.asMap().entries.map((entry) {
          int index = entry.key + 1; // Serial number starts from 1
          User user = entry.value;
          return DataRow(
            cells: [
              DataCell(
                Center(
                  child: Text('$index'),
                ),
              ), // Serial number cell (horizontally centered)
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(user.name), // Align name to the left
                    ),
                  ],
                ),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align children to the end
                  children: [
                    Text(user.rank), // Align rank to the left
                    SizedBox(width: 10),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.rank_icon),
                    ),
                  ],
                ),
              ),
              DataCell(
                Center(
                  child: Text(user.points),
                ),
              ), // Centered points
              DataCell(
                Center(
                  child: Text(user.department),
                ),
              ), // Centered department
            ],
          );
        }).toList(),
      ),
    );
  }
}
