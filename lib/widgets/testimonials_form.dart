import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/config.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestimonialsForm extends StatefulWidget {
  const TestimonialsForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<TestimonialsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  File? _selectedImage;
  // To handle the form submission
  // void _submitForm() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     final String name = _nameController.text;
  //     // final String number = _numberController.text;
  //     final String message = _messageController.text;

  //     print("Feedback submitted: $name, $message");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Thank you for your feedback!")),
  //     );

  //     _nameController.clear();

  //     _messageController.clear();
  //   }
  // }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = _nameController.text;
      final String message = _messageController.text;

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Constants.baseUrl}testimonials.php'),
        );

        request.fields['name'] = name;
        request.fields['message'] = message;

        if (_selectedImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_image',
              _selectedImage!.path,
            ),
          );
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          print('Server response: $responseBody');
          final jsonResponse = jsonDecode(responseBody);

          if (jsonResponse['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'])),
            );
            _nameController.clear();
            _messageController.clear();
            setState(() {
              _selectedImage = null;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'])),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit testimonial.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error occurred: $e');
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Your Testimonials',
          style: TextStyle(
            fontFamily: 'CenturyGothic',
            fontSize: 20.0,
            color: Palette.secondaryColor,
          ),
        ),
        // backgroundColor: const Color(0xFFD68D54),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name field
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
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Your Name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // // Phone number field
                    // const Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     'Enter Your Number :',
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
                    //   controller: _numberController,
                    //   decoration: InputDecoration(
                    //     prefixIcon:
                    //         const Icon(Icons.phone, color: Color(0xFFD68D54)),
                    //     hintText: 'Mobile Number',
                    //     hintStyle: TextStyle(color: Colors.black54),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(30.0),
                    //       borderSide:
                    //           const BorderSide(color: Color(0xFFD68D54)),
                    //     ),
                    //   ),
                    //   keyboardType: TextInputType.phone,
                    //   inputFormatters: [
                    //     LengthLimitingTextInputFormatter(
                    //         10), // Limit the number of characters to 10
                    //     FilteringTextInputFormatter
                    //         .digitsOnly, // Allow only digits
                    //   ],
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your phone number';
                    //     } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    //       return 'Please enter a valid 10-digit phone number';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // const SizedBox(height: 16),
// Select Image Button (added above the message field)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Your Image :',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Palette.secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'EuclidCircularA Medium',
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image, color: Color(0xFFD68D54)),
                        label: Text(
                          'Select Image',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          // padding: const EdgeInsets.symmetric(vertical: 15.0),
                          alignment: Alignment
                              .centerLeft, // Aligns the content to the start
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 16.0), // Adds horizontal spacing
                          backgroundColor: Color.fromARGB(255, 245, 245, 245),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Color(0xFFD68D54)),
                          ),
                          // alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Display the selected image (if any)
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 50.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(height: 0), // No image selected

                    const SizedBox(height: 16),

                    // Message field
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
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFD68D54)),
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

                    // Submit button
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
        ),
      ),
    );
  }
}
