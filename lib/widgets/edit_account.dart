import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/utility.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../pages/startup/splash.dart';
import '../viewmodels/main_container_viewmodel.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  String phoneNumber = '';
  bool isLoading = true;
  File? _selectedImage;
  // final nameController = TextEditingController();
  // final addressController = TextEditingController();
  // final emailController = TextEditingController();
  // final pincodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Add variables for user details
  String id = '';
  String name = '';
  String email = '';
  String address = '';
  String pincode = '';

  @override
  void initState() {
    super.initState();
    Utility.showProgress(true);
    loadUserData(); // Call the method to load user data from SharedPreferences
  }

  Future<void> _editAccount() async {
    if (_formKey.currentState!.validate()) {
      // Get the updated values from the controllers
      String updatedName = _nameController.text;
      String updatedNumber = _numberController.text;
      String updatedEmail = _emailController.text;
      String updatedAddress = _addressController.text;

      // Get the user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(
          'id'); // Ensure you have the user ID stored in SharedPreferences

      if (userId == null) {
        // Handle case where user ID is not available
        print('User ID not found');
        return;
      }

      // Prepare the data to send in the request
      Map<String, String> data = {
        'id': userId,
        'name': updatedName,
        'phone_number': updatedNumber,
        'email_id': updatedEmail,
        'address': updatedAddress,
      };

      // Make the API request to update the user data
      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}edit_account.php'),
          body: data,
        );

        if (response.statusCode == 200) {
          // Handle success
          print('User details updated successfully');

          // Show a Snackbar with a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your account details have been updated."),
              backgroundColor: Color(0xFFD68D54),
            ),
          );

          // Clear the user data from SharedPreferences to log them out
          await prefs
              .clear(); // This will remove all stored data, or you can remove specific keys

          // Optionally, navigate to the login screen or another page
          Navigator.pop(context); // Close the dialog.
          _logout(context); // Replace '/login' with your login screen route
        } else {
          print('Failed to update user details');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Reset the application state or any global variables you need to reset
    Application.userId = '';
    Application.phoneNumber = '';
    Application.languageId = '';
    Application.pincode = '';
    Application.address = '';
    // Reset any provider state or other application states
    Provider.of<MainContainerViewModel>(context, listen: false).setIndex(0);

    // Navigate to SplashScreen or MainContainer, clearing the navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  // Method to load user data from SharedPreferences
  Future<void> loadUserData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user data from SharedPreferences
      String? mobileNumber = prefs.getString('mobileNumber');

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print('Mobile number not found in SharedPreferences');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Load the rest of the user data from SharedPreferences
      id = prefs.getString('id') ?? 'Default ID';
      name = prefs.getString('name') ?? 'Default Name';
      email = prefs.getString('email') ?? 'default@example.com';
      address = prefs.getString('address') ?? 'Default Address';
      pincode = prefs.getString('pincode') ?? 'Default Pincode';
      phoneNumber = mobileNumber;

      // Update the UI with the fetched data by setting the text controllers
      _nameController.text = name;
      _emailController.text = email;
      _addressController.text = address;
      _numberController.text = phoneNumber;
      _bioController.text =
          ''; // You can set this if you have a bio in your user data.

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      print('id: $id');
      print('Name: $name');
      print('Mobile Number: $phoneNumber');
      print('Email: $email');
      print('Address: $address');
      print('Pincode: $pincode');
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store the picked image file
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Palette.scaffoldColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Palette.black, size: 18.0),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Edit Account',
                  style: TextStyle(color: Palette.black, fontSize: 18.0)),
              backgroundColor: Palette.appBarColor,
              elevation: 10.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  _buildProfileDetailDisplay(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Palette.scaffoldColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Palette.black, size: 18.0),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Edit Account',
                  style: TextStyle(color: Palette.black, fontSize: 18.0)),
              backgroundColor: Palette.appBarColor,
              elevation: 10.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Top half with background color (fixed height)
                  Container(
                    color: Color(
                        0xFFD68D54), // Set the background color for the top half
                    height: MediaQuery.of(context).size.height /
                        3.3, // Half the screen height
                    child: Column(
                      children: [
                        // Edit button above profile details
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Navigate to the EditAccount page
                                _pickImage();
                              },
                            ),
                          ),
                        ),
                        // Profile details displayed below the Edit button
                        _buildProfileDetailDisplay(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Name :',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Palette.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'EuclidCircularA Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFFD68D54)),
                              hintText: 'Your Name',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    const BorderSide(color: Color(0xFFD68D54)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Number :',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Palette.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'EuclidCircularA Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _numberController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone,
                                  color: Color(0xFFD68D54)),
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    const BorderSide(color: Color(0xFFD68D54)),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  10), // Limit the number of characters to 10
                              FilteringTextInputFormatter
                                  .digitsOnly, // Allow only digits
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (!RegExp(r'^[0-9]{10}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid 10-digit phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mail ID :',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Palette.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'EuclidCircularA Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email,
                                  color: Color(0xFFD68D54)),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    const BorderSide(color: Color(0xFFD68D54)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mail';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Address :',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Palette.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'EuclidCircularA Medium',
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_pin,
                                  color: Color(0xFFD68D54)),
                              hintText: 'Address',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    const BorderSide(color: Color(0xFFD68D54)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          // const SizedBox(height: 16),
                          // const Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     'Bio :',
                          //     style: TextStyle(
                          //       fontSize: 16.0,
                          //       color: Palette.secondaryColor,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'EuclidCircularA Medium',
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 4),
                          // TextFormField(
                          //   controller: _bioController,
                          //   decoration: InputDecoration(
                          //     hintText: 'Bio',
                          //     hintStyle: TextStyle(color: Colors.black54),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //       borderSide:
                          //           const BorderSide(color: Color(0xFFD68D54)),
                          //     ),
                          //   ),
                          //   maxLines: 4,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please enter your Bio';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _editAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD68D54),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Updated widget to display profile details
  Widget _buildProfileDetailDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Palette.shadowColor.withOpacity(0.1),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          children: [
            // CircleAvatar with selected or default image
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Palette.secondaryColor2,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!) // Show the selected image
                  : AssetImage('assets/images/white_logo.webp')
                      as ImageProvider, // Default image
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD68D54)),
                  ),
                  Text(
                    phoneNumber,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  Text(
                    _emailController.text,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  Text(
                    _addressController.text,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
