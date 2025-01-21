// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:ios_insecure_screen_detector/ios_insecure_screen_detector.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../config/config.dart';
// import '../../services/mysql_db_service.dart';
// import '../../utils/utility.dart';

// class UserAccount extends StatefulWidget {
//   const UserAccount({
//     super.key,
//   });

//   @override
//   _UserAccountState createState() => _UserAccountState();
// }

// class _UserAccountState extends State<UserAccount> {
//   String phoneNumber = '';
//   bool isLoading = false;
//   final nameController = TextEditingController();
//   final addressController = TextEditingController();
//   final emailController = TextEditingController();
//   final pincodeController = TextEditingController();
//   final countryController = TextEditingController();
//   final stateController = TextEditingController();
//   final cityController = TextEditingController();
//   final phoneController = TextEditingController();
//   String countryValue = "";
//   String stateValue = "";
//   String cityValue = "";
//   String url = Constants.isDevelopment
//       ? Constants.devBackendUrl
//       : Constants.prodBackendUrl;
//   // final IosInsecureScreenDetector _insecureScreenDetector =
//   //     IosInsecureScreenDetector();
//   bool _isCaptured = false;

//   Future<void> getUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     final phonenumber = prefs.getString('phonenumber') ?? '';
//     // Utility.printLog();
//     setState(() {
//       phoneNumber =
//           prefs.getString('mobileNumber') ?? 'No mobile number available';
//       phoneController.text = phonenumber;
//     });
//     Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
//       requestType: RequestType.GET,
//       url: '$url/users/getUserDetails/$phoneNumber',
//     );

//     bool _status = _getNews['status'];
//     var _data = _getNews['data'];
//     // Utility.printLog(_data);
//     if (_status) {
//       // data loaded
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       if (_data['data'][0]['email_id'].toString() != 'null') {
//         emailController.text = _data['data'][0]['email_id'].toString();
//         prefs.setString('email', _data['data'][0]['email_id'].toString());
//       }
//       if (_data['data'][0]['name'].toString() != 'null') {
//         nameController.text = _data['data'][0]['name'].toString();
//         prefs.setString('name', _data['data'][0]['name'].toString());
//         Application.userName = _data['data'][0]['name'].toString();
//       }
//       if (_data['data'][0]['address'].toString() != 'null') {
//         addressController.text = _data['data'][0]['address'].toString();
//         prefs.setString('address', _data['data'][0]['address'].toString());
//       }
//       if (_data['data'][0]['pincode'].toString() != 'null') {
//         pincodeController.text = _data['data'][0]['pincode'].toString();
//         prefs.setString('address', _data['data'][0]['pincode'].toString());
//       }
//       setState(() => isLoading = true);
//       Utility.showProgress(false);
//     } else {
//       Utility.printLog('Something went wrong.');
//       Utility.showProgress(false);
//       Utility.databaseErrorPopup(context);
//     }
//   }

//   // Future<void> saveUserDetails() async {
//   //   Utility.showProgress(true);
//   //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
//   //       requestType: RequestType.POST,
//   //       url: '$url/users/saveUserDetails/$phoneNumber',
//   //       body: {
//   //         'name': nameController.text,
//   //         'email_id': emailController.text,
//   //         'address': addressController.text,
//   //         'pincode': pincodeController.text
//   //       });

//   //   bool _status = _getNews['status'];
//   //   var _data = _getNews['data'];
//   //   // Utility.printLog(_data);
//   //   if (_status) {
//   //     // data loaded
//   //     if (_data['message'].toString() == 'success') {
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       prefs.setString('email', emailController.text);
//   //       prefs.setString('name', nameController.text);
//   //       prefs.setString('address', addressController.text);
//   //       prefs.setString('pincode', pincodeController.text);
//   //       Application.userName = nameController.text;
//   //       Utility.showProfileEditSuccessMessage(
//   //           'Updated successfully', 'Your data is updated!!', context);
//   //     } else {
//   //       Utility.showProfileEditSuccessMessage(
//   //           'Some error occured', 'Try again in some time!!', context);
//   //     }
//   //     setState(() => isLoading = true);
//   //     Future.delayed(const Duration(milliseconds: 1000), () {
//   //       Navigator.pop(context);
//   //       Navigator.pop(context);
//   //     });
//   //     Utility.showProgress(false);
//   //   } else {
//   //     Utility.printLog('Something went wrong.');
//   //     Utility.showProgress(false);
//   //     Utility.databaseErrorPopup(context);
//   //   }
//   // }

//   _filterRetriever() async {
//     try {
//       final result = await InternetAddress.lookup('cheftarunabirla.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         Utility.printLog('connected');
//         getUserDetails();
//       }
//     } on SocketException catch (_) {
//       Utility.printLog('not connected');
//       Utility.showProgress(false);
//       Utility.noInternetPopup(context);
//     }
//   }

//   @override
//   void initState() {
//     // _filterRetriever();
//     // if (Platform.isIOS) {
//     //   _insecureScreenDetector.initialize();
//     //   _insecureScreenDetector.addListener(() {
//     //     Utility.printLog('add event listener');
//     //     Utility.forceLogoutUser(context);
//     //     // Utility.forceLogout(context);
//     //   }, (isCaptured) {
//     //     Utility.printLog('screen recording event listener');
//     //     // Utility.forceLogoutUser(context);
//     //     // Utility.forceLogout(context);
//     //     setState(() {
//     //       _isCaptured = isCaptured;
//     //     });
//     //   });
//     // }
//     Utility.showProgress(true);
//     if (!kIsWeb) {
//       _filterRetriever();
//     } else {
//       getUserDetails();
//     }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isCaptured
//         ? const Center(
//             child: Text(
//               'You are not allowed to do screen recording',
//               style: TextStyle(
//                 fontFamily: 'EuclidCircularA Regular',
//                 fontSize: 20.0,
//                 color: Palette.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           )
//         : Scaffold(
//             backgroundColor: Palette.scaffoldColor,
//             appBar: AppBar(
//               leading: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Palette.black,
//                   size: 18.0,
//                 ),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               title: const Text(
//                 'Account',
//                 style: TextStyle(
//                   color: Palette.black,
//                   fontSize: 18.0,
//                   fontFamily: 'EuclidCircularA Medium',
//                 ),
//               ),
//               backgroundColor: Palette.appBarColor,
//               elevation: 10.0,
//               shadowColor: Palette.shadowColor.withOpacity(0.1),
//               centerTitle: false,
//             ),
//             body: !isLoading
//                 ? Container()
//                 : SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           height: 30.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 24.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Palette.shadowColor.withOpacity(0.1),
//                                   blurRadius: 5.0, // soften the shadow
//                                   spreadRadius: 0.0, //extend the shadow
//                                   offset: const Offset(
//                                     0.0, // Move to right 10  horizontally
//                                     0.0, // Move to bottom 10 Vertically
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               // enabled: false,
//                               readOnly: true,
//                               onChanged: (value) {},
//                               // keyboardType: TextInputType.multiline,
//                               // minLines: 1,
//                               // maxLines: 1,
//                               controller: phoneController,
//                               style: const TextStyle(
//                                 fontFamily: 'EuclidCircularA Regular',
//                               ),
//                               autofocus: false,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   MdiIcons.phoneOutline,
//                                 ),
//                                 counterText: "",
//                                 hintText: "",
//                                 focusColor: Palette.contrastColor,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xffffffff),
//                                       width: 1.3,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xffffffff), width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 filled: true,
//                                 fillColor: const Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 24.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Palette.shadowColor.withOpacity(0.1),
//                                   blurRadius: 5.0, // soften the shadow
//                                   spreadRadius: 0.0, //extend the shadow
//                                   offset: const Offset(
//                                     0.0, // Move to right 10  horizontally
//                                     0.0, // Move to bottom 10 Vertically
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               onChanged: (value) {},
//                               keyboardType: TextInputType.multiline,
//                               minLines: 1,
//                               maxLines: 1,
//                               controller: nameController,
//                               style: const TextStyle(
//                                 fontFamily: 'EuclidCircularA Regular',
//                               ),
//                               autofocus: false,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   MdiIcons.formatTextVariant,
//                                 ),
//                                 counterText: "",
//                                 hintText: "Enter your full name",
//                                 focusColor: Palette.contrastColor,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xffffffff),
//                                       width: 1.3,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xffffffff), width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 filled: true,
//                                 fillColor: const Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 24.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Palette.shadowColor.withOpacity(0.1),
//                                   blurRadius: 5.0, // soften the shadow
//                                   spreadRadius: 0.0, //extend the shadow
//                                   offset: const Offset(
//                                     0.0, // Move to right 10  horizontally
//                                     0.0, // Move to bottom 10 Vertically
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               onChanged: (value) {},
//                               keyboardType: TextInputType.multiline,
//                               minLines: 1,
//                               maxLines: 1,
//                               controller: emailController,
//                               style: const TextStyle(
//                                 fontFamily: 'EuclidCircularA Regular',
//                               ),
//                               autofocus: false,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   MdiIcons.emailOutline,
//                                 ),
//                                 counterText: "",
//                                 hintText: "Enter your email",
//                                 focusColor: Palette.contrastColor,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xffffffff),
//                                       width: 1.3,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xffffffff), width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 filled: true,
//                                 fillColor: const Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 24.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Palette.shadowColor.withOpacity(0.1),
//                                   blurRadius: 5.0, // soften the shadow
//                                   spreadRadius: 0.0, //extend the shadow
//                                   offset: const Offset(
//                                     0.0, // Move to right 10  horizontally
//                                     0.0, // Move to bottom 10 Vertically
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               onChanged: (value) {},
//                               keyboardType: TextInputType.multiline,
//                               minLines: 1,
//                               maxLines: 5,
//                               controller: addressController,
//                               style: const TextStyle(
//                                 fontFamily: 'EuclidCircularA Regular',
//                               ),
//                               autofocus: false,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   MdiIcons.mapMarkerOutline,
//                                 ),
//                                 counterText: "",
//                                 hintText: "Enter your address",
//                                 focusColor: Palette.contrastColor,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xffffffff),
//                                       width: 1.3,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xffffffff), width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 filled: true,
//                                 fillColor: const Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 0.0, horizontal: 24.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Palette.shadowColor.withOpacity(0.1),
//                                   blurRadius: 5.0, // soften the shadow
//                                   spreadRadius: 0.0, //extend the shadow
//                                   offset: const Offset(
//                                     0.0, // Move to right 10  horizontally
//                                     0.0, // Move to bottom 10 Vertically
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             child: TextField(
//                               onChanged: (value) {},
//                               keyboardType: TextInputType.multiline,
//                               minLines: 1,
//                               maxLines: 5,
//                               controller: pincodeController,
//                               style: const TextStyle(
//                                 fontFamily: 'EuclidCircularA Regular',
//                               ),
//                               autofocus: false,
//                               decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   MdiIcons.formTextboxPassword,
//                                 ),
//                                 counterText: "",
//                                 hintText: "Enter your pincode",
//                                 focusColor: Palette.contrastColor,
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xffffffff),
//                                       width: 1.3,
//                                     ),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xffffffff), width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 8.0, horizontal: 16.0),
//                                 filled: true,
//                                 fillColor: const Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(
//                         //       vertical: 0.0, horizontal: 24.0),
//                         //   child: GestureDetector(
//                         //     onTap: () {
//                         //       // if(addressController.text.isNotEmpty)
//                         //       setState(() {
//                         //         isLoading = false;
//                         //       });
//                         //       saveUserDetails();
//                         //     },
//                         //     child: Container(
//                         //       height: 48.0,
//                         //       decoration: BoxDecoration(
//                         //         borderRadius: BorderRadius.circular(10),
//                         //         color: Palette.contrastColor,
//                         //         boxShadow: [
//                         //           BoxShadow(
//                         //             color: const Color(0xffFFF0D0)
//                         //                 .withOpacity(0.0),
//                         //             blurRadius: 30.0, // soften the shadow
//                         //             spreadRadius: 0.0, //extend the shadow
//                         //             offset: const Offset(
//                         //               0.0, // Move to right 10  horizontally
//                         //               0.0, // Move to bottom 10 Vertically
//                         //             ),
//                         //           ),
//                         //         ],
//                         //       ),
//                         //       child: const Center(
//                         //         child: Text(
//                         //           'Save',
//                         //           style: TextStyle(
//                         //             color: Colors.white,
//                         //             fontSize: 16.0,
//                         //             fontFamily: 'EuclidCircularA Medium',
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ));
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class UserAccount extends StatefulWidget {
// //   const UserAccount({
// //     super.key,
// //   });

// //   @override
// //   _UserAccountState createState() => _UserAccountState();
// // }

// // class _UserAccountState extends State<UserAccount> {
// //   String name = '';
// //   String mobileNumber = '';
// //   String email = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserData();
// //   }

// //   // Method to load user data from SharedPreferences
// //   Future<void> _loadUserData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       name = prefs.getString('name') ?? 'No name available';
// //       mobileNumber =
// //           prefs.getString('mobileNumber') ?? 'No mobile number available';
// //       email = prefs.getString('email') ?? 'No email available';
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('User Account'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Name: $name',
// //               style: TextStyle(
// //                 fontSize: 18.0,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 8.0),
// //             Text(
// //               'Mobile Number: $mobileNumber',
// //               style: TextStyle(
// //                 fontSize: 16.0,
// //               ),
// //             ),
// //             SizedBox(height: 8.0),
// //             Text(
// //               'Email: $email',
// //               style: TextStyle(
// //                 fontSize: 16.0,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:chef_taruna_birla/pages/profile/my_orders.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart';

import '../../utils/utility.dart';
import '../../widgets/edit_account.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  String phoneNumber = '';
  bool isLoading = true;
  double totalAmount = 0.0;
  int totalOrders = 0;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final pincodeController = TextEditingController();

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
    fetchTotalAmountAndOrders();
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

      // Update the UI with the fetched data
      nameController.text = name;
      emailController.text = email;
      addressController.text = address;
      pincodeController.text = pincode;

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

  Future<void> fetchTotalAmountAndOrders() async {
    // Get the current user's ID (You should replace this with the actual user ID)
    final String url =
        '${Constants.baseUrl}get_wallet.php?user_id=${Application.userId}';

    // Print the request URL for debugging
    print("Request URL: $url");

    try {
      final response = await http.get(Uri.parse(url));

      // Print the response status code and the response body
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final data = json.decode(response.body);

        setState(() {
          // Convert 'total_amount' to a double if it's a string
          totalAmount = double.tryParse(data['total_amount']) ?? 0.0;
          totalOrders = data['total_orders'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Print any error message if something goes wrong
      print("Error: $e");
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
              title: const Text('Account',
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
              title: const Text('Account',
                  style: TextStyle(color: Palette.black, fontSize: 18.0)),
              backgroundColor: Palette.appBarColor,
              elevation: 10.0,
            ),
            // body: SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       const SizedBox(height: 30.0),
            //       _buildProfileDetailDisplay(),
            //       const SizedBox(height: 20.0),
            //     ],
            //   ),
            // ),
            body: SingleChildScrollView(
                child: Column(children: [
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
                            Icons.edit_square,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Navigate to the EditAccount page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditAccount()),
                            );
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
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align heading to the left
                  children: [
                    // Heading above the row
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom: 20.0), // Space between heading and row
                      child: Text(
                        'Wallet', // Replace with your actual heading text
                        style: TextStyle(
                          fontFamily: 'EuclidCircularA Regular',
                          fontSize: 18.0, // Adjust size as needed
                          fontWeight: FontWeight
                              .bold, // Optional: Makes the heading bold
                          color:
                              Palette.contrastColor, // Adjust color as needed
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyOrders(),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.contrastColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: TextStyle(
                                          fontFamily: 'EuclidCircularA Regular',
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '\Rs ${totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: 'EuclidCircularA Regular',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyOrders(),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.contrastColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Order',
                                        style: TextStyle(
                                          fontFamily: 'EuclidCircularA Regular',
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '$totalOrders',
                                        style: TextStyle(
                                          fontFamily: 'EuclidCircularA Regular',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 24.0,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align heading to the left
                  children: [
                    // Heading above the row
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.0), // Space between heading and row
                      child: Text(
                        'Bio', // Replace with your actual heading text
                        style: TextStyle(
                          fontFamily: 'EuclidCircularA Regular',
                          fontSize: 18.0, // Adjust size as needed
                          fontWeight: FontWeight
                              .bold, // Optional: Makes the heading bold
                          color:
                              Palette.contrastColor, // Adjust color as needed
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Palette.contrastColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contrary to popular belief, Lorem Ipsum is not simply random text.',
                                        style: TextStyle(
                                          fontFamily: 'EuclidCircularA Regular',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.secondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ])));
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
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Palette.secondaryColor2,
              backgroundImage: AssetImage(
                  'assets/images/white_logo.webp'), // Replace with the path to your asset image
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameController.text,
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
                    emailController.text,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                  Text(
                    addressController.text,
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
