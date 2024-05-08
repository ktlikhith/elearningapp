import 'package:flutter/material.dart';
import 'package:elearning/services/leaderboardservice.dart';
import 'package:shimmer/shimmer.dart';

class leaderboard extends StatefulWidget {
  final String token;

  leaderboard({Key? key, required this.token}) : super(key: key);

  @override
  _leaderboardState createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
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
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Leader Board', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          isLoading
              ? _buildShimmerSkeleton()
              : users.isNotEmpty
                  ? buildLeaderBoard()
                  : Text(
                      'Will get back to you once Leaderboard is updated',
                      textAlign: TextAlign.center,
                    ),
        ],
      ),
    );
  }
Widget _buildShimmerSkeleton() {
  return SizedBox(
    height: 300, // Adjust height as needed
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


  Widget buildLeaderBoard() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: [
          DataColumn(label: Text('#No', style: TextStyle(color: Colors.black))),
          DataColumn(label: Text('Name', style: TextStyle(color: Colors.black))),
          DataColumn(label: Text('Rank', style: TextStyle(color: Colors.black))),
          DataColumn(label: Text('Points', style: TextStyle(color: Colors.black))),
          DataColumn(label: Text('Department', style: TextStyle(color: Colors.black))),
        ],
        rows: List<DataRow>.generate(
          users.length,
          (index) => DataRow(
            cells: [
              DataCell(Text((index + 1).toString())),
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(users[index].profileUrl),
                    ),
                    SizedBox(width: 10),
                    Text(users[index].name),
                  ],
                ),
              ),
              DataCell(Text(users[index].rank.toString())),
              DataCell(Text(users[index].points.toString())),
              DataCell(Text(users[index].department)),
            ],
          ),
        ),
      ),
    );
  }
}
