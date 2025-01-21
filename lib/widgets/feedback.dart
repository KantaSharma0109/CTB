import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _numberController.text = prefs.getString('mobileNumber') ?? '';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String number = _numberController.text;
      final String message = _messageController.text;

      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('id');

      if (userId == null || userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User ID not found. Please log in.")),
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('${Constants.baseUrl}feedback.php'),
          body: {
            'user_id': userId,
            'name': name,
            'number': number,
            'message': message,
          },
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thank you for your feedback!")),
            );
            _messageController.clear();
          } else if (result['status'] == 'duplicate') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("You have already submitted feedback.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(result['message'] ?? "Something went wrong.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Server error. Please try again later.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Your Feedback',
            style: TextStyle(
              fontFamily: 'CenturyGothic',
              fontSize: 24.0,
              color: Palette.secondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Your Name :',
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
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFFD68D54)),
                    hintText: 'Your Name',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Color(0xFFD68D54)),
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
                    'Enter Your Number :',
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
                    prefixIcon:
                        const Icon(Icons.phone, color: Color(0xFFD68D54)),
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Color(0xFFD68D54)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        10), // Limit the number of characters to 10
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Your Message :',
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
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Color(0xFFD68D54)),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD68D54),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Submit',
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
        ],
      ),
    );
  }
}
