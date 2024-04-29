import 'package:flutter/material.dart';
import 'package:elearning/services/leaderboardservice.dart';

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
              ? Center(child: CircularProgressIndicator())
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
