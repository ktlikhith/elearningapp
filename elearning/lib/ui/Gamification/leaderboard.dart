

// import 'package:flutter/material.dart';
// import 'package:elearning/services/leaderboardservice.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';

// class Leaderboard extends StatefulWidget {
//   final String token;

//   Leaderboard({Key? key, required this.token}) : super(key: key);

//   @override
//   LeaderboardState createState() => LeaderboardState();
// }

// class LeaderboardState extends State<Leaderboard> {
//   List<User> users = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchLeaderboard();
//   }

//   Future<void> fetchLeaderboard() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final leaderboardUsers = await LeaderboardService.fetchLeaderboard(widget.token);
//       setState(() {
//         users = List<User>.from(leaderboardUsers);
//       });
//     } catch (e) {
//       print('Error fetching leaderboard: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//     Future<void> refresh() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final leaderboardUsers = await LeaderboardService.fetchLeaderboard(widget.token);
//       setState(() {
//         users = List<User>.from(leaderboardUsers);
//       });
//     } catch (e) {
//       print('Error fetching leaderboard: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8),
//             child: Shimmer.fromColors(
//               baseColor: Colors.black,
//               highlightColor: Theme.of(context).secondaryHeaderColor,
//               child: Text(
//                 'Leaderboard',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           SizedBox(height: 8),
//           isLoading
//               ? _buildShimmerSkeleton()
//               : users.isNotEmpty
//                   ? Column(
//                       children: [
//                         buildTop3Members(context),
//                          SizedBox(height: 16),
//                         buildLeaderBoard(),
//                       ],
//                     )
//                   : Text(
//                       'Will get back to you once Leaderboard is updated',
//                       textAlign: TextAlign.center,
//                     ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShimmerSkeleton() {
//     return SizedBox(
//       height: 300,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: 5,
//           itemBuilder: (context, index) {
//             return Container(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           height: 16,
//                           color: Colors.grey[300],
//                         ),
//                         SizedBox(height: 8),
//                         Container(
//                           width: 150,
//                           height: 16,
//                           color: Colors.grey[300],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   String imageWithToken(String imgUrl) {
//     return '$imgUrl?token=${widget.token}';
//   }

//   Widget buildTop3Members(BuildContext context) {
//     if (users.length < 3) {
//       return SizedBox.shrink();
//     }

//     User top1User = users[0];
//     User top2User = users[1];
//     User top3User = users[2];

//     return Container(
//       margin: EdgeInsets.all(8),
//       padding: EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//          color: Theme.of(context).primaryColor,
       
//       ),
//       child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Align(
//         alignment: Alignment.topLeft,
//         child: Text(
//           "Current Table Toppers",
//           style: TextStyle(
//             color: Colors.white, // Adjust the color as needed
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//       ),

     
//        Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.end,

//         children: [
          
//           buildUserWidget(context, top2User, 2, 30, Color(0xFF1CA3DE)),
//           buildUserWidget(context, top1User, 1, 0, Color(0xFF3ACBE8), isCenter: true),
//           buildUserWidget(context, top3User, 3, 30, Color.fromARGB(255, 19, 139, 225),),
//         ],
//       ),
//     ],
//       ),
//     );
    
  
//   }

//   Widget buildUserWidget(BuildContext context, User user, int rank, double topMargin, Color backgroundColor, {bool isCenter = false}) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final avatarRadius = isCenter ? 40.0 : 30.0;
//     final textWidth = screenWidth * 0.25; // Adjust text width relative to screen width

    
//     return Column(
//       children: [
        
//         Stack(
//           alignment: Alignment.topCenter,
//           children: [
//             Container(
//               width: screenWidth *0.25,
//               margin: EdgeInsets.only(top: topMargin),
//               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: isCenter ? 40 : 20), // Extra space for the crown
//                   CircleAvatar(
//                     radius: avatarRadius,   //isCenter ? 40 : 30,
//                     backgroundImage: NetworkImage(imageWithToken(user.image)),
//                   ),
//                   SizedBox(height: 8),
//                   SizedBox(
//                     width: textWidth, // Set a fixed width to prevent overflow
//                     child: Text(
//                       user.name,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).highlightColor,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       softWrap: true,
//                       textAlign: TextAlign.center, // Center align text
//                     ),
//                   ),
//                   Text(
//                     '${user.points}',
//                     style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//             if (rank == 1)
//               Positioned(
//                 top: 15,
//                 child:Image.asset('assets/gamificatinn/crown.png',width: 30,height: 30,)
//                 //  FaIcon(
//                 //   FontAwesomeIcons.crown,
//                 //   size: 30,
//                 //   color: Colors.yellow,
//                 // ),
//               ),
//             if (rank != 1)
//               Positioned(
//                 top: 100,
//                 left: 20,
//                 child: CircleAvatar(
//                   radius: 10,
//                   backgroundColor: Colors.white,
//                   child: Text(
//                     '$rank',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }



//   Widget buildLeaderBoard() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8),
//         child: DataTable(
//           headingRowColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
//           dataRowColor: MaterialStateColor.resolveWith((states) => Theme.of(context).hintColor.withOpacity(0.2)),
//           columnSpacing: 20,
//           columns: [
//             DataColumn(
//               label: Center(
//                 child: Text('#No', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
//               ),
//             ),
//             DataColumn(
//               label: Center(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 60),
//                   child: Text('Name', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Text('Rank', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
//                 ),
//               ),
//             ),
//             DataColumn(
//               label: Center(
//                 child: Text('Points', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
//               ),
//             ),
//             DataColumn(
//               label: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Text('Department', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
//                 ),
//               ),
//             ),
//           ],
//           rows: users.asMap().entries.map((entry) {
//             int index = entry.key;
//             User user = entry.value;

//             return DataRow(
//               cells: [
//                 DataCell(
//                   index < 3
//                       ? Shimmer.fromColors(
//                           baseColor: Colors.black,
//                           highlightColor: Theme.of(context).secondaryHeaderColor,
//                           child: Center(
//                             child: Text('${index + 1}'),
//                           ),
//                         )
//                       : Center(
//                           child: Text('${index + 1}'),
//                         ),
//                 ),
//                 DataCell(
//                   index < 3
//                       ? Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: NetworkImage(imageWithToken(user.image)),
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Shimmer.fromColors(
//                                 baseColor: Colors.black,
//                                 highlightColor: Theme.of(context).secondaryHeaderColor,
//                                 child: Text(user.name),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: NetworkImage(imageWithToken(user.image)),
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(user.name),
//                             ),
//                           ],
//                         ),
//                 ),
//                 DataCell(
//                   index < 3
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Shimmer.fromColors(
//                               baseColor: Colors.black,
//                               highlightColor: Theme.of(context).secondaryHeaderColor,
//                               child: Text(user.rank),
//                             ),
//                             SizedBox(width: 10),
//                             CircleAvatar(
//                               radius: 18,
//                               backgroundImage: NetworkImage(imageWithToken(user.rank_icon)),
//                             ),
//                           ],
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(user.rank),
//                             SizedBox(width: 10),
//                             CircleAvatar(
//                               radius: 18,
//                               backgroundImage: NetworkImage(imageWithToken(user.rank_icon)),
//                             ),
//                           ],
//                         ),
//                 ),
//                 DataCell(
//                   index < 3
//                       ? Shimmer.fromColors(
//                           baseColor: Colors.black,
//                           highlightColor: Theme.of(context).secondaryHeaderColor,
//                           child: Center(
//                             child: Text(user.points),
//                           ),
//                         )
//                       : Center(
//                           child: Text(user.points),
//                         ),
//                 ),
//                 DataCell(
//                   index < 3
//                       ? Shimmer.fromColors(
//                           baseColor: Colors.black,
//                           highlightColor: Theme.of(context).secondaryHeaderColor,
//                           child: Center(
//                             child: Text(user.department),
//                           ),
//                         )
//                       : Center(
//                           child: Text(user.department),
//                         ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:elearning/services/leaderboardservice.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class Leaderboard extends StatefulWidget {
  final String token;

  Leaderboard({Key? key, required this.token}) : super(key: key);

  @override
  LeaderboardState createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Theme.of(context).secondaryHeaderColor,
              child: Text(
                'Leaderboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 8),
          StreamBuilder<List<User>>(
            stream: LeaderboardService.streamLeaderboard(widget.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerSkeleton();
              } else if (snapshot.hasError) {
            
             SchedulerBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Something went wrong in leaderboard data please try again.'
)),
    );
    });
        return _buildShimmerSkeleton();
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Leaderboard is empty'));
              } else {
                final users = snapshot.data!;
                return Column(
                  children: [
                    buildTop3Members(context, users),
                    SizedBox(height: 16),
                    buildLeaderBoard(users),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    return SizedBox(
      height: 300,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 5,
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
  Widget buildTop3Members(BuildContext context, List<User> users) {
    if (users.length < 3) {
      return SizedBox.shrink();
    }

    User top1User = users[0];
    User top2User = users[1];
    User top3User = users[2];

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Current Table Toppers",
              style: TextStyle(
                color: Colors.white, // Adjust the color as needed
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildUserWidget(context, top2User, 2, 30, Color(0xFF1CA3DE)),
              buildUserWidget(context, top1User, 1, 0, Color(0xFF3ACBE8), isCenter: true),
              buildUserWidget(context, top3User, 3, 30, Color.fromARGB(255, 19, 139, 225)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildUserWidget(BuildContext context, User user, int rank, double topMargin, Color backgroundColor, {bool isCenter = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = isCenter ? 40.0 : 30.0;
    final textWidth = screenWidth * 0.25;

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: screenWidth * 0.25,
              margin: EdgeInsets.only(top: topMargin),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SizedBox(height: isCenter ? 40 : 20),
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: NetworkImage(user.image),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: textWidth,
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).highlightColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '${user.points}',
                    style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (rank == 1)
              Positioned(
                top: 15,
                child: Image.asset(
                  'assets/gamificatinn/crown.png',
                  width: 30,
                  height: 30,
                ),
              ),
            if (rank != 1)
              Positioned(
                top: 100,
                left: 20,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
 String imageWithToken(String imgUrl) {
    return '$imgUrl?token=${widget.token}';
  }
  Widget buildLeaderBoard(List<User> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColor),
          dataRowColor: MaterialStateColor.resolveWith((states) => Theme.of(context).hintColor.withOpacity(0.2)),
          columnSpacing: 20,
          columns: [
            DataColumn(
              label: Center(
                child: Text('#No', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
              ),
            ),
            DataColumn(
              label: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Text('Name', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Rank', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text('Points', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
              ),
            ),
            DataColumn(
              label: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Department', style: TextStyle(fontSize: 18, color: Theme.of(context).highlightColor)),
                ),
              ),
            ),
          ],
          rows: users.asMap().entries.map((entry) {
            int index = entry.key;
            User user = entry.value;

            return DataRow(
              cells: [
                DataCell(
                  index < 3
                      ? Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Theme.of(context).secondaryHeaderColor,
                          child: Center(
                            child: Text('${index + 1}'),
                          ),
                        )
                      : Center(
                          child: Text('${index + 1}'),
                        ),
                ),
                DataCell(
                  index < 3
                      ? Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageWithToken(user.image)),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Shimmer.fromColors(
                                baseColor: Colors.black,
                                highlightColor: Theme.of(context).secondaryHeaderColor,
                                child: Text(user.name),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageWithToken(user.image)),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(user.name),
                            ),
                          ],
                        ),
                ),
                DataCell(
                  index < 3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Theme.of(context).secondaryHeaderColor,
                              child: Text(user.rank),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(imageWithToken(user.rank_icon)),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(user.rank),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(imageWithToken(user.rank_icon)),
                            ),
                          ],
                        ),
                ),
                DataCell(
                  index < 3
                      ? Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Theme.of(context).secondaryHeaderColor,
                          child: Center(
                            child: Text(user.points),
                          ),
                        )
                      : Center(
                          child: Text(user.points),
                        ),
                ),
                DataCell(
                  index < 3
                      ? Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Theme.of(context).secondaryHeaderColor,
                          child: Center(
                            child: Text(user.department),
                          ),
                        )
                      : Center(
                          child: Text(user.department),
                        ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
