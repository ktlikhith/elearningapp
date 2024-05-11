import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/updateProfile_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class EditProfilePage extends StatefulWidget {
  final String token;

  const EditProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late String _token;
  late int _userId;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    _fetchUserId();
  }

  void _fetchUserId() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    try {
      final userInfo = await SiteConfigApiService.getUserId(_token);
      setState(() {
        _userId = userInfo['id'];
        _isLoading = false; // Stop loading
      });
    } catch (error) {
      // Handle errors
      print(error);
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  String _username = 'username';
  String _schoolType = 'school';
  String _dobType = 'dob';
  String _phone = '9979176562';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Call the service method to update user profile
      setState(() {
        _isLoading = true; // Start loading
      });
      ProfileService profileService = ProfileService('https://lxp-demo2.raptechsolutions.com/webservice/rest/server.php');
      profileService.updateUserProfile(
        token: _token,
        userId: _userId,
        username: _usernameController.text.trim(),
        schoolType: _schoolType,
        schoolName: _schoolNameController.text.trim(),
        dobType: _dobType,
        dobValue: _dobController.text.trim(),
        phone: _phoneController.text.trim(),
      ).then((success) {
        if (success) {
          // Update successful
          // You can navigate to a success screen or show a success message
          setState(() {
            _isLoading = false; // Stop loading on success
          });
        } else {
          // Update failed
          // You can show an error message
          setState(() {
            _isLoading = false; // Stop loading on failure
          });
        }
      }).catchError((error) {
        // Handle errors
        print(error);
        // You can show an error message
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(RouterManger.homescreen,arguments: widget.token);
          },
        ),
      ),
      body: _isLoading
          ? _buildLoadingSkeleton() // Show shimmer loading skeleton while loading
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _schoolNameController,
                      decoration: InputDecoration(labelText: 'School Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the school name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(labelText: 'Date of Birth'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              color: Colors.white,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              color: Colors.white,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              color: Colors.white,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // Placeholder onPressed function
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
