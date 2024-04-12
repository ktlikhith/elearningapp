import 'package:elearning/bloc/authbloc.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/ui/Dashboard/dues.dart';
import 'package:elearning/ui/Dashboard/continue.dart';
import 'package:elearning/ui/Dashboard/upcoming_event.dart';
import 'package:elearning/ui/Navigation%20Bar/navigationanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DashboardScreen extends StatelessWidget {
  final String token;

  const DashboardScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardPage(token: token); // Pass the token to DashboardPage
  }
}



class DashboardPage extends StatefulWidget {
  final String token;

  const DashboardPage({Key? key, required this.token}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}


class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String _userName = ''; 
  String _userprofile='';// Default value set to an empty string

 @override
  void initState() {
    super.initState();
    _fetchUserInfo(widget.token);
    
  }

  Future<void> _fetchUserInfo(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final fullName = userInfo['fullname'];
      final function=userInfo['functions'];
      final userprofile=userInfo['userpictureurl'];

      setState(() {
        _userName = fullName;
        _userprofile = userprofile;
      });
    } catch (e) {
      print('Error fetching user information: $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: const DecorationImage(
                image: AssetImage('assets/images/img1.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () {
              // Handle notification icon press
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouterManger.myprofile,arguments:widget.token);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: _userprofile.isNotEmpty ? NetworkImage(_userprofile) : null,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, $_userName!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Explore your courses and start learning.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 25.0),
             
              AutoScrollableSections(token: widget.token),
              const SizedBox(height: 15.0),
              const UpcomingEventsSection(),
              const SizedBox(height: 15.0),
              CustomDashboardWidget(token: widget.token),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(initialIndex: 0),
    );
  }
}
