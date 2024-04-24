import 'package:flutter/material.dart';

Widget buildLeaderBoard() {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FractionColumnWidth(0.05),
        1: FractionColumnWidth(0.4),
        2: FractionColumnWidth(0.13),
        3: FractionColumnWidth(0.13),
        4: FractionColumnWidth(0.3),

      },
      children: [
        TableRow(
          children: [
            TableCell(child: Center(child: Text('#'))),
            TableCell(child: Center(child: Text('Name'))),
            TableCell(child: Center(child: Text('Rank'))),
            TableCell(child: Center(child: Text('Points'))),
             TableCell(child: Center(child: Text('Department'))),
          ],
        ),
        buildLeaderBoardRow('1', 'John Doe', 'Caded', '500','Engineering', 'assets/images/profile1.jpg'),
        buildLeaderBoardRow('2', 'Jane Smith', 'Caded','500', 'Marketing', 'assets/images/profile2.jpg'),
        buildLeaderBoardRow('3', 'Mike Johnson', '-', '500','Finance', 'assets/images/profile3.jpg'),
      ],
    );
  }

  TableRow buildLeaderBoardRow(String slNo, String name, String rank, String Department, String department, String profileImageUrl) {
    return TableRow(
      children: [
        TableCell(child: Center(child: Text(slNo))),
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15, // Adjust the radius as needed
                backgroundImage: AssetImage(profileImageUrl),
              ),
              SizedBox(width: 10), // Add spacing between profile picture and name
              Text(name),
            ],
          ),
        ),
        TableCell(child: Center(child: Text(rank))),
        TableCell(child: Center(child: Text(Department))),
         TableCell(child: Center(child: Text(department))),
      ],
    );
   }

