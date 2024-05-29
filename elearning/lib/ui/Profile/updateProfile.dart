import 'package:elearning/routes/routes.dart';
import 'package:elearning/services/auth.dart';
import 'package:elearning/services/profile_service.dart';
import 'package:elearning/services/updateProfile_service.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; 

class EditProfilePage extends StatefulWidget {
  final String token;

  const EditProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$'); 
  late String _profilePictureUrl = '';

  late String _token;
  late int _userId;
  late String _username = '';
  late String _firstname = '';
  late String _lastname = '';
  late String _phone= '';
  bool _profileUpdated = false;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _token = widget.token;

    _fetchUserId();
    _fetchProfileData(widget.token);
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
        _username = userInfo['username'];
        _usernameController.text = _username;
        _firstname = userInfo['firstname'];
        _firstnameController.text= _firstname;
        _lastname = userInfo['lastname'] ?? '';
        _lastnameController.text = _lastname;
      });
    } catch (error) {
      // Handle errors
      print(error);
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> _fetchProfileData(String token) async {
    try {
      final data = await ProfileAPI.fetchProfileData(token);
      setState(() {
        final profilePictureMatch = RegExp(r'src="([^"]+)"').firstMatch(data['user_info'][0]['studentimage']);
        if (profilePictureMatch != null) {
          _profilePictureUrl = profilePictureMatch.group(1)!;
        }
        _phone = data['user_info'][0]['mobileno'];
        _phoneController.text= _phone;
      });
    } catch (error) {
      // Handle errors
      print(error);
    }
  }

  Future<void> _uploadPhoto() async {
    await ProfileAPI.uploadPhoto(widget.token);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      ProfileService profileService =
          ProfileService('${Constants.baseUrl}/webservice/rest/server.php');
      profileService
          .updateUserProfile(
        token: _token,
        userId: _userId,
        username: _username,
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        phone: _phoneController.text.trim(),
      )
          .then((success) {
        if (success) {
          setState(() {
            _profileUpdated = true;
          });
          print('Profile update successful');
          setState(() {
            _isLoading = false; // Stop loading on success
          });
        } else {
          print('Profile update failed');
          setState(() {
            _isLoading = false; // Stop loading on failure
          });
        }
      }).catchError((error) {
        print('Error updating profile: $error');
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      });
    }
  }

  // Validator function for phone number field
  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth < 600 ? 200.0 : 300.0;
    final buttonPadding = screenWidth < 600 ? EdgeInsets.symmetric(vertical: 12, horizontal: 20) : EdgeInsets.symmetric(vertical: 14, horizontal: 30);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? _buildLoadingSkeleton() // Show shimmer loading skeleton while loading
          : SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profilePictureUrl.isNotEmpty ? NetworkImage(_profilePictureUrl) : null,
                    ),
                    IconButton(
                      onPressed: _uploadPhoto,
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'First Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstnameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Last Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _lastnameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.person, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                enabled: false, 
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.phone, color: Colors.grey),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                validator: phoneValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: buttonPadding,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Theme.of(context).secondaryHeaderColor,
                          ),
                          child: Text(
                            'Update Now',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      if (_profileUpdated)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Profile has been updated',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
