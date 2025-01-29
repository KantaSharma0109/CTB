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
  File? _selectedProfileImage;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedProfileImage == null) {
        // Show error if profile image is not selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a profile image')),
        );
        return; // Prevent form submission
      }

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
            await http.MultipartFile.fromPath('image', _selectedImage!.path),
          );
        }

        if (_selectedProfileImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
                'profile_image', _selectedProfileImage!.path),
          );
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = jsonDecode(responseBody);

          if (jsonResponse['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonResponse['message'])),
            );
            _nameController.clear();
            _messageController.clear();
            setState(() {
              _selectedImage = null;
              _selectedProfileImage = null;
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
      }
    }
  }

  Future<void> _pickImage(bool isProfileImage) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _selectedProfileImage = File(pickedFile.path);
        } else {
          _selectedImage = File(pickedFile.path);
        }
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Select Image:',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Palette.secondaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        // Button for selecting the main image
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(false),
                          icon: Icon(Icons.image, color: Color(0xFFD68D54)),
                          label: Text(
                            'Select Image',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 16.0),
                            backgroundColor: Color.fromARGB(255, 245, 245, 245),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFFD68D54)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Display selected image with remove button overlay
                        if (_selectedImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                _selectedImage!,
                                height: 50, // Adjust height as needed
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Color(0xFFD68D54)),
                                onPressed: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                              ),
                            ],
                          ),

                        const SizedBox(height: 16),

                        // Text description
                        Text(
                          'Select Profile Image:',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Palette.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Button for selecting the profile image
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(true),
                          icon: Icon(Icons.image, color: Color(0xFFD68D54)),
                          label: Text(
                            'Select Profile Image',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 16.0),
                            backgroundColor: Color.fromARGB(255, 245, 245, 245),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xFFD68D54)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Display selected profile image with remove button overlay
                        if (_selectedProfileImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                _selectedProfileImage!,
                                height: 50, // Adjust height as needed
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Color(0xFFD68D54)),
                                onPressed: () {
                                  setState(() {
                                    _selectedProfileImage = null;
                                  });
                                },
                              ),
                            ],
                          ),
                      ],
                    ),

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
