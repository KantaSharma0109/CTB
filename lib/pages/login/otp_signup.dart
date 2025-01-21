import 'dart:convert';

import 'package:chef_taruna_birla/config/config.dart';
import 'package:chef_taruna_birla/pages/main_container.dart';
import 'package:chef_taruna_birla/viewmodels/main_container_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/utility.dart';

class OtpUpScreen extends StatefulWidget {
  final String mobileNumber;
  final String id;
  final String name;
  final String address;
  final String email;
  final String pincode;
  String verificationId;

  OtpUpScreen(
      {super.key,
      required this.mobileNumber,
      required this.verificationId,
      required this.id,
      required this.name,
      required this.address,
      required this.pincode,
      required this.email});

  @override
  OtpUpScreenState createState() => OtpUpScreenState();
}

class OtpUpScreenState extends State<OtpUpScreen> {
  // TextEditingControllers for OtpIn input fields
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<TextEditingController> OtpInControllers =
      List.generate(6, (_) => TextEditingController());
  bool showLoading = false;
  // String deviceToken = '';
  String deviceToken = Application.deviceToken;

  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  void _onOtpInChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('id', userData['id'] ?? '');
      await prefs.setString('name', userData['name'] ?? '');
      await prefs.setString('mobileNumber', userData['phone_number'] ?? '');
      await prefs.setString('email', userData['email_id'] ?? '');
      await prefs.setString('address', userData['address'] ?? '');
      await prefs.setString('pincode', userData['pincode'] ?? '');
      String savedUserId = prefs.getString('id') ?? '';
      String savedName = prefs.getString('name') ?? 'Default Name';
      String savedPhoneNumber = prefs.getString('mobileNumber') ?? '';
      String savedAddress = prefs.getString('address') ?? 'Default Address';
      String savedPincode = prefs.getString('pincode') ?? '000000';
      String savedLanguageId = prefs.getString('language_id') ?? '1';

      // Assign values to your global state variables
      Application.userId = savedUserId;
      Application.phoneNumber = savedPhoneNumber;
      Application.languageId = savedLanguageId;
      Application.pincode = savedPincode;
      Application.address = savedAddress;
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _resendOtpIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OtpIn has been resent to ${widget.mobileNumber}'),
      ),
    );
  }

  Future<void> insert_user() async {
    final String url = "${Constants.baseUrl}user_data.php";

    final Map<String, String> body = {
      'mobileNumber': widget.mobileNumber,
      'name': widget.name,
      'email': widget.email,
      'address': widget.address,
      'pincode': widget.pincode,
      'deviceToken': deviceToken,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );
      print("Request Body: $body"); // Log the request
      print("Response: ${response.body}"); // Log the response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == "true") {
          print("User inserted successfully");
          print("User ID: ${data['data']['id']}"); // Print the user ID
          print("User Details: ${data['data']}"); // Print all details
          await saveUserData(
              data['data']); // Pass the response data to saveUserData
          final prefs = await SharedPreferences.getInstance();
          print(prefs.getString('mobileNumber'));
        } else {
          print("Failed to insert user: ${data['error']}");
        }
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error while inserting user: $e");
    }
  }

  Future<void> getAppData() async {
    await Provider.of<MainContainerViewModel>(context, listen: false)
        .getAppData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signimg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),

                      Text(
                        "Enter Otp",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD68D54),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Text(
                      //   "Sent on: $deviceToken",
                      //   style: TextStyle(
                      //     color: Colors.grey,
                      //     fontSize: 14.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   "Sent on: ${widget.id}",
                      //   style: TextStyle(
                      //     color: Colors.grey,
                      //     fontSize: 14.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 40.0,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: TextField(
                              controller: OtpInControllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "", // Hide the counter
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              // Move to the next box when a digit is entered
                              onChanged: (value) =>
                                  _onOtpInChanged(value, index),
                              onEditingComplete: () {
                                // Move focus to the next field when done
                                if (index < 5) {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[index + 1]);
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 20),

                      // Resend OtpIn Button
                      TextButton(
                        onPressed: _resendOtpIn,
                        child: Text(
                          "Resend Otp",
                          style: TextStyle(
                            color: Color(0xFFD68D54),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Join the OTP inputs into a single string
                            String OtpInCode = OtpInControllers.map(
                                (controller) => controller.text).join();

                            // Create PhoneAuthCredential with the OTP
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: OtpInCode,
                            );

                            try {
                              // Sign in the user with the OTP credential
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                              // Call insert_user to insert user data into the server
                              await insert_user();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('is_logged_in', true);

                              // Ensure that app data is loaded
                              await getAppData();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainContainer(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } catch (e) {
                              // Log error if any occurs during sign-in, data insertion, or navigation
                              Utility.printLog(
                                  'Error during sign-in or navigation: $e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFD68D54), // Button color
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
