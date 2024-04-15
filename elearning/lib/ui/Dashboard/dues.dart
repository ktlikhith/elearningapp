import 'dart:async';
import 'package:elearning/services/auth.dart';
import 'package:flutter/material.dart';



class AutoScrollableSections extends StatefulWidget {
  final String token;

  const AutoScrollableSections({Key? key, required this.token}) : super(key: key);

  @override
  _AutoScrollableSectionsState createState() => _AutoScrollableSectionsState();
}


class _AutoScrollableSectionsState extends State<AutoScrollableSections> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  String _past='';
  String _soon='';
  String _later='';

  @override
void initState() {
  super.initState();
  _startAutoScroll();
  _fetchDueInfo(widget.token); // Call _fetchdue with the token passed from the dashboard
}

  Future<void> _fetchDueInfo(String token) async {
  try {
    final userInfo = await SiteConfigApiService.getUserId(token);
    //final baseUrl = userInfo['siteurl'];
   // final wstoken = 'your_wstoken'; // Add your wstoken here
    final userId = userInfo['id'];
 // Extract function names
    final functionNames = userInfo['functions'];
    //final List<String> functionNames = functions.map<String>((function) => function['name']).toList();
    final dueInfo = await DueApiService.getDueInfo(token, userId, functionNames);
    // Handle due information as needed
    final past=dueInfo['pastcountactivity'];
    final soon=dueInfo['countsevendays'];
    final later=dueInfo['countthirtydays'];
   
    setState(() {
        _past = past;
        _soon = soon;
        _later= later;
      });
  } catch (e) {
    print('Error fetching due information: $e');
  }
}

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          // If reached the end, scroll back to the start
          _scrollController.animateTo(
            0,
            duration: Duration(seconds: 1),
            curve: Curves.ease,
          );
        } else {
          // Scroll to the end
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          buildSection("Past Due", '$_past', Colors.red),
          buildSection("Due Soon", '$_soon', Colors.yellow),
          buildSection("Due Later", '$_later', Colors.grey),
        ],
      ),
    );
  }
}


  Widget buildSection(String title, String number, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12.0),
           gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
         Color(0xFFFFA000),    Color(0xFFD500F9), // Replace with your desired gradient colors
         // Example colors used here
        ],
      ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: const Icon(
                Icons.gamepad,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 25.0),
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7.0, width: 50.0),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

