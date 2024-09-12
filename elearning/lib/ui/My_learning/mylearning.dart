// import 'package:elearning/routes/routes.dart';
// import 'package:elearning/services/report_service.dart';
// import 'package:elearning/ui/Dashboard/dues.dart';
// import 'package:elearning/ui/My_learning/buildsection.dart';
// import 'package:elearning/ui/My_learning/course.dart';
// import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:shimmer/shimmer.dart'; 
// import 'package:provider/provider.dart';

// class LearningScreen extends StatelessWidget {
//   final String token;

//   const LearningScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ReportProvider(token),
//       child: MyLearningPage(token: token),
//     );
//   }
// }

// class MyLearningPage extends StatefulWidget {
//   final String token;

//   const MyLearningPage({Key? key, required this.token}) : super(key: key);

//   @override
//   _MyLearningPageState createState() => _MyLearningPageState();
// }

// class _MyLearningPageState extends State<MyLearningPage> {
//   bool _isSearching = false;

//   void _handleSearchPressed() {
//     setState(() {
//       _isSearching = !_isSearching;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).primaryColor,
//           title: const Row(
//             children: [
//               Text('My Learning'),
//             ],
//           ),
//           // automaticallyImplyLeading: false,
//           // actions: <Widget>[
//           //   IconButton(
//           //     icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
//           //     onPressed: _handleSearchPressed,
//           //   ),
//           // ],
//           // bottom: _isSearching
//           //     ? const PreferredSize(
//           //         preferredSize: Size.fromHeight(56.0),
//           //         child: Padding(
//           //           padding: EdgeInsets.all(8.0),
//           //           child: TextField(
//           //             decoration: InputDecoration(
//           //               hintText: 'Search...',
//           //               border: OutlineInputBorder(),
//           //             ),
//           //           ),
//           //         ),
//           //       )
//           //     : null,
//         ),
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: Consumer<ReportProvider>(
//           builder: (context, reportProvider, _) {
//             return SingleChildScrollView(
//               child: MyLearningAppBody(
//                 token: widget.token,
//                 reportData: reportProvider.reportData,
//                 isLoading: reportProvider.isLoading,
//               ),
//             );
//           },
//         ),
//         bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 1, token: widget.token),
//       ),
//     );
//   }
// }

// class MyLearningAppBody extends StatelessWidget {
//   final String token;
//   final Report? reportData;
//   final bool isLoading;

//   const MyLearningAppBody({
//     Key? key,
//     required this.token,
//     required this.reportData,
//     required this.isLoading,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 0.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const SizedBox(height: 18.0),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: <Widget>[
//                 buildSection(
//                   iconPath: 'assets/learning icons/total activity.png',
//                   number: reportData?.totalNoActivity ?? 0,
//                   title: 'Totalactivity',
//                   context: context,
//                   Color1:Color.fromARGB(255, 221, 218, 23),
//                 ),
//                 buildSection(
//                   iconPath: 'assets/learning icons/Completed Activity.png',
//                   number: reportData?.completedActivity ?? 0,
//                   title: 'Completed',
//                   context: context,
//                     Color1:Color.fromARGB(255, 61, 243, 37),
//                 ),
//                 buildSection(
//                   iconPath: 'assets/learning icons/Average.png',
//                   number: reportData?.averageGrade ?? 0,
//                   title: 'Avg_Grade',
//                   context: context,
//                     Color1:Color.fromARGB(255, 32, 247, 233),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 6.0),
//           isLoading ? _buildLoadingShimmer() : BuildCourseSections(token: token),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingShimmer() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 16.0),
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.0),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 200,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(height: 16.0),
//                 Container(
//                   width: double.infinity,
//                   height: 20.0,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(height: 8.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 100.0,
//                       height: 12.0,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 16.0),
//                     Container(
//                       width: 80.0,
//                       height: 12.0,
//                       color: Colors.grey,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.0),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ReportProvider with ChangeNotifier {
//   final String token;
//   final ReportService reportService = ReportService();
//   Report? reportData;
//   bool isLoading = true;

//   ReportProvider(this.token) {
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final data = await reportService.fetchReport(token);
//       reportData = data;
//     } catch (e) {
//       print('Error fetching data: $e');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/report_service.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/My_learning/buildsection.dart';
import 'package:elearning/ui/My_learning/course.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart'; 
import 'package:provider/provider.dart';

class LearningScreen extends StatelessWidget {
  final String token;

  const LearningScreen({Key? key, required this.token}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportProvider(token),
      child: MyLearningPage(token: token),
    );
  }
}

class MyLearningPage extends StatefulWidget {
  final String token;
  

  const MyLearningPage({Key? key, required this.token}) : super(key: key);

  @override
  _MyLearningPageState createState() => _MyLearningPageState();
}

class _MyLearningPageState extends State<MyLearningPage> {
  bool _isSearching = false;
  String _searchQuery = '';

  void _handleSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
      }
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(RouterManger.homescreen, arguments: widget.token);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
           leading: Padding(
            padding: const EdgeInsets.only(left: 5.0,right: 0),
            child: SvgPicture.asset('assets/appbarsvg/graduate-student-svgrepo-com.svg'),
          ),
          leadingWidth: 60,
          title: _isSearching
              ? TextField(
                  onChanged: _updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              : const Text('My Learning'),
              centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
              onPressed: _handleSearchPressed,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: ()async{
            setState(() {
                   reportProvider.fetchData();
            });

         
          },
          child: Consumer<ReportProvider>(
            builder: (context, reportProvider, _) {
              return SingleChildScrollView(
                child: MyLearningAppBody(
                  token: widget.token,
                  reportData: reportProvider.reportData,
                  isLoading: reportProvider.isLoading,
                  searchQuery: _searchQuery,
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 1, token: widget.token),
      ),
    );
  }
}

class MyLearningAppBody extends StatelessWidget {
  final String token;
  final Report? reportData;
  final bool isLoading;
  final String searchQuery;

  const MyLearningAppBody({
    Key? key,
    required this.token,
    required this.reportData,
    required this.isLoading,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 18.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                buildSection(
                  iconPath: 'assets/learning icons/total activity.png',
                  number: reportData?.totalNoActivity ?? 0,
                  title: 'Totalactivity',
                  context: context,
                  Color1: Color.fromARGB(255, 221, 218, 23),
                ),
                buildSection(
                  iconPath: 'assets/learning icons/Completed Activity.png',
                  number: reportData?.completedActivity ?? 0,
                  title: 'Completed',
                  context: context,
                  Color1: Color.fromARGB(255, 61, 243, 37),
                ),
                buildSection(
                  iconPath: 'assets/learning icons/Average.png',
                  number: reportData?.averageGrade ?? 0,
                  title: 'Avg_Grade',
                  context: context,
                  Color1: Color.fromARGB(255, 32, 247, 233),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          isLoading ? _buildLoadingShimmer() : BuildCourseSections(token: token, searchQuery: searchQuery),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100.0,
                      height: 12.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 16.0),
                    Container(
                      width: 80.0,
                      height: 12.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReportProvider with ChangeNotifier {
  final String token;
  final ReportService reportService = ReportService();
  Report? reportData;
  bool isLoading = true;
  

  ReportProvider(this.token) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      if(token!=null){
      final data = await reportService.fetchReport(token);
      reportData = data;
      }
     
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading = false;
       print(reportData);
      notifyListeners();
    }
  }
}
