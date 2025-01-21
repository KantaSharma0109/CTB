import 'dart:io';

import 'package:chef_taruna_birla/pages/common/webview_page.dart';
import 'package:chef_taruna_birla/pages/startup/splash.dart';

import 'package:chef_taruna_birla/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/config.dart';

import '../../viewmodels/main_container_viewmodel.dart';
import '../../viewmodels/product_page_viewmodel.dart';
import '../common/gallery_page.dart';
import '../profile/my_books.dart';
import '../profile/my_courses.dart';
import '../profile/my_orders.dart';
import '../profile/user_account.dart';
import '../wallet/wallet_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String phoneNumber = '';
  String id = '';
  String name = '';
  String email = '';
  String address = '';
  String pincode = '';
  bool isLoading = false;
  bool isSearching = false;
  String searchQuery = '';
  RateMyApp? ratemyapp = RateMyApp();
  static const playstoreId = 'com.cheftarunbirla';
  static const appstoreId = 'com.technotwist.tarunaBirla';
  late Widget Function(RateMyApp) builder;
  late final RateMyAppInitializedCallback onInitialized;

  Future<void> loadUserData() async {
    setState(() {
      isLoading = true; // Show a loading indicator
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get user data from SharedPreferences
      String? mobileNumber = prefs.getString('mobileNumber');

      if (mobileNumber == null || mobileNumber.isEmpty) {
        print('Mobile number not found in SharedPreferences');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Load the rest of the user data from SharedPreferences
      String? id = prefs.getString('id') ?? 'Default Name';

      String? name = prefs.getString('name') ?? 'Default Name';
      String? email = prefs.getString('email') ?? 'default@example.com';
      String? address = prefs.getString('address') ?? 'Default Address';
      String? pincode = prefs.getString('pincode') ?? 'Default pincode';

      // Update the state with the fetched data
      setState(() {
        this.id = id;
        this.name = name;
        this.email = email;
        this.address = address;
        phoneNumber = mobileNumber;
        this.pincode = pincode;
      });
      print('id: $id');
      print('Name: $name');
      print('Mobile Number: $mobileNumber');
      print('Email: $email');
      print('Address: $address');
      print('pincode: $pincode');
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide the loading indicator
      });
    }
  }

  Future<RateMyAppBuilder> rateMyApp(BuildContext context) async {
    return RateMyAppBuilder(
      onInitialized: (context, ratemyapp) {
        setState(() {
          this.ratemyapp = ratemyapp;
        });
      },
      builder: (context) => ratemyapp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : builder(ratemyapp!),
      rateMyApp: RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 7,
        minLaunches: 10,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: 'com.cheftarunbirla',
        appStoreIdentifier: 'com.technotwist.tarunaBirla',
      ),
    );
  }

  void openRateDialog(BuildContext context) {
    ratemyapp?.showRateDialog(context);
  }

  _filterRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String phonenumber = prefs.getString('phonenumber') ?? '';
    // print();
    setState(() {
      phoneNumber = phonenumber;
    });

    if (phoneNumber.isNotEmpty) {
      initRateMyApp();
    }
  }

  @override
  void initState() {
    // _filterRetriever();
    super.initState();
    loadUserData();
  }

  Future<void> initRateMyApp() async {
    await ratemyapp?.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onInitialized(context, ratemyapp!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
          //  phoneNumber.isEmpty
          //     ? const LoginPage()
          //     :

          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Padding(
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
                          '$name',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD68D54)),
                        ),
                        Text(
                          phoneNumber,
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                        Text(
                          '$email',
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 5.0,
          //     horizontal: 24.0,
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10.0),
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Palette.shadowColor.withOpacity(0.1),
          //           blurRadius: 5.0, // soften the shadow
          //           spreadRadius: 0.0, //extend the shadow
          //           offset: const Offset(
          //             0.0, // Move to right 10  horizontally
          //             0.0, // Move to bottom 10 Vertically
          //           ),
          //         ),
          //       ],
          //     ),
          //     child: TextField(
          //       onChanged: (value) {
          //         if (value.isNotEmpty) {
          //           setState(() {
          //             isSearching = true;
          //           });
          //           Provider.of<ProductPageViewModel>(context, listen: false)
          //               .setSelectedCategory(
          //                   Provider.of<MainContainerViewModel>(context,
          //                           listen: false)
          //                       .productCategories[0]
          //                       .name);
          //           Provider.of<ProductPageViewModel>(context, listen: false)
          //               .getSearchedProducts(value, context);
          //         } else {
          //           setState(() {
          //             isSearching = false;
          //           });
          //           Provider.of<ProductPageViewModel>(context, listen: false)
          //               .setSelectedCategory(
          //                   Provider.of<MainContainerViewModel>(context,
          //                           listen: false)
          //                       .productCategories[0]
          //                       .name);
          //           // getProductData();
          //         }
          //       },
          //       // controller: phoneController,
          //       style: const TextStyle(
          //         fontFamily: 'EuclidCircularA Regular',
          //       ),
          //       autofocus: false,
          //       decoration: InputDecoration(
          //         prefixIcon: Icon(
          //           MdiIcons.magnify,
          //           color: Palette.contrastColor,
          //           size: 30,
          //         ),
          //         counterText: "",
          //         hintText: "Search Here...",
          //         focusColor: Palette.contrastColor,
          //         focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(
          //               color: Color(0xffffffff),
          //               width: 1.3,
          //             ),
          //             borderRadius: BorderRadius.circular(10.0)),
          //         enabledBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(
          //                 color: Color(0xffffffff), width: 1.0),
          //             borderRadius: BorderRadius.circular(10.0)),
          //         contentPadding: const EdgeInsets.symmetric(
          //             vertical: 8.0, horizontal: 16.0),
          //         filled: true,
          //         fillColor: const Color(0xffffffff),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Palette.contrastColor,
                            fontSize: 20.0,
                            fontFamily: 'EuclidCircularA Medium'),
                      ),
                      // Text('Mobile Number: $phoneNumber',
                      //     style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserAccount(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.accountOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Text(
                          'Account',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'EuclidCircularA Medium'),
                        ),
                        // Text('Mobile Number: $phoneNumber',
                        //     style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Platform.isIOS
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Platform.isIOS ? 5.0 : 0.0,
                    horizontal: 24.0,
                  ),
                  child: !Platform.isIOS
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WalletPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Palette.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Palette.shadowColor.withOpacity(0.1),
                                  blurRadius: 5.0, // soften the shadow
                                  spreadRadius: 0.0, //extend the shadow
                                  offset: const Offset(
                                    0.0, // Move to right 10  horizontally
                                    0.0, // Move to bottom 10 Vertically
                                  ),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 0.0),
                                    child: CircleAvatar(
                                      backgroundColor: Palette.secondaryColor2,
                                      // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                                      radius: 25.0,
                                      child: Icon(
                                        MdiIcons.currencyInr,
                                        color: Palette.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 5.0),
                                    child: Text(
                                      'Wallet',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: 'EuclidCircularA Medium'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18.0,
                                      color: Palette.contrastColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrders(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.cartOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'My Orders',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 5.0,
          //     horizontal: 24.0,
          //   ),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const MyCourses(),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Palette.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Palette.shadowColor.withOpacity(0.1),
          //             blurRadius: 5.0, // soften the shadow
          //             spreadRadius: 0.0, //extend the shadow
          //             offset: const Offset(
          //               0.0, // Move to right 10  horizontally
          //               0.0, // Move to bottom 10 Vertically
          //             ),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Expanded(
          //             flex: 2,
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(
          //                   vertical: 10.0, horizontal: 0.0),
          //               child: CircleAvatar(
          //                 backgroundColor: Palette.secondaryColor2,
          //                 // backgroundImage: AssetImage('assets/images/blog.jpeg'),
          //                 radius: 25.0,
          //                 child: Icon(
          //                   MdiIcons.playCircleOutline,
          //                   color: Palette.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             flex: 5,
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 0.0, horizontal: 5.0),
          //               child: Row(
          //                 children: const [
          //                   Text(
          //                     'My Courses',
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 16.0,
          //                         fontFamily: 'EuclidCircularA Medium'),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const Expanded(
          //             flex: 1,
          //             child: Padding(
          //               padding: EdgeInsets.all(5.0),
          //               child: Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: 18.0,
          //                 color: Palette.contrastColor,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 5.0,
          //     horizontal: 24.0,
          //   ),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const MyBooks(),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Palette.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Palette.shadowColor.withOpacity(0.1),
          //             blurRadius: 5.0, // soften the shadow
          //             spreadRadius: 0.0, //extend the shadow
          //             offset: const Offset(
          //               0.0, // Move to right 10  horizontally
          //               0.0, // Move to bottom 10 Vertically
          //             ),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Expanded(
          //             flex: 2,
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(
          //                   vertical: 10.0, horizontal: 0.0),
          //               child: CircleAvatar(
          //                 backgroundColor: Palette.secondaryColor2,
          //                 // backgroundImage: AssetImage('assets/images/blog.jpeg'),
          //                 radius: 25.0,
          //                 child: Icon(
          //                   MdiIcons.bookOutline,
          //                   color: Palette.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             flex: 5,
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 0.0, horizontal: 5.0),
          //               child: Row(
          //                 children: const [
          //                   Text(
          //                     'My Books',
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 16.0,
          //                         fontFamily: 'EuclidCircularA Medium'),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const Expanded(
          //             flex: 1,
          //             child: Padding(
          //               padding: EdgeInsets.all(5.0),
          //               child: Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: 18.0,
          //                 color: Palette.contrastColor,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const MyBooks(),
              //     ),
              //   );
              // },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GalleryPage(
                      itemId: '',
                      itemCategory: '',
                      isItemGallery: false,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.bookOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Our Gallery',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Utility.showLanguagePopup(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.googleTranslate,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Language',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                      url: 'http://www.cheftarunabirla.com/aboutUs/',
                      title: 'About Us',
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.informationVariant,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'About Us',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                rateMyApp(context);
                ratemyapp?.showRateDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.starOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Rate Us',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                      url: 'https://linktr.ee/cheftarunabirla',
                      title: 'Contact Us',
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.phone,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                      url: 'http://www.cheftarunabirla.com/faq/',
                      title: 'FAQ',
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.commentQuestionOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'FAQ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 5.0,
          //     horizontal: 24.0,
          //   ),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const WebviewPage(
          //             url: 'http://www.cheftarunabirla.com/feedback1',
          //             title: 'Feedback',
          //           ),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10.0),
          //         color: Palette.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Palette.shadowColor.withOpacity(0.1),
          //             blurRadius: 5.0, // soften the shadow
          //             spreadRadius: 0.0, //extend the shadow
          //             offset: const Offset(
          //               0.0, // Move to right 10  horizontally
          //               0.0, // Move to bottom 10 Vertically
          //             ),
          //           ),
          //         ],
          //       ),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Expanded(
          //             flex: 2,
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(
          //                   vertical: 10.0, horizontal: 0.0),
          //               child: CircleAvatar(
          //                 backgroundColor: Palette.secondaryColor2,
          //                 radius: 25.0,
          //                 child: Icon(
          //                   MdiIcons.messageTextOutline,
          //                   color: Palette.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           Expanded(
          //             flex: 5,
          //             child: Padding(
          //               padding: EdgeInsets.symmetric(
          //                   vertical: 0.0, horizontal: 5.0),
          //               child: Row(
          //                 children: [
          //                   Text(
          //                     'Feedback',
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 16.0,
          //                         fontFamily: 'EuclidCircularA Medium'),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           const Expanded(
          //             flex: 1,
          //             child: Padding(
          //               padding: EdgeInsets.all(5.0),
          //               child: Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: 18.0,
          //                 color: Palette.contrastColor,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                      url: 'http://www.cheftarunabirla.com/privacy-policy-2/',
                      title: 'Privacy Policy',
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.bookLockOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 24.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebviewPage(
                      url: 'http://www.cheftarunabirla.com/tnc/',
                      title: 'Terms & Conditions',
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowColor.withOpacity(0.1),
                      blurRadius: 5.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: const Offset(
                        0.0, // Move to right 10  horizontally
                        0.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          // backgroundImage: AssetImage('assets/images/blog.jpeg'),
                          radius: 25.0,
                          child: Icon(
                            MdiIcons.shieldLockOutline,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 5.0),
                        child: Row(
                          children: const [
                            Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: 'EuclidCircularA Medium'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              // Wrap the _onShare method call in a lambda function
              onTap: () => _onShare(
                  context), // This ensures _onShare is called only when tapped
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          radius: 25.0,
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'EuclidCircularA Medium'),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GestureDetector(
              onTap: _showLogoutDialog,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: const Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: CircleAvatar(
                          backgroundColor: Palette.secondaryColor2,
                          radius: 25.0,
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: 'EuclidCircularA Medium'),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.0,
                          color: Palette.contrastColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  void _onShare(BuildContext context) async {
    // Load the image from assets
    final ByteData bytes = await rootBundle.load('assets/images/splash1.jpeg');
    final Uint8List list = bytes.buffer.asUint8List();

    // Create a temporary file to save the image
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.jpg').create();
    await file.writeAsBytes(list);

    // Convert the file path to XFile
    final xFile = XFile(file.path);

    // Get the box for sharing position
    final box = context.findRenderObject() as RenderBox?;

    // Share the file using Share.shareXFiles
    await Share.shareXFiles(
      [xFile],
      text:
          'To explore more products and courses click on the link given below\n\n👇https://play.google.com/store/apps/details?id=com.cheftarunbirla',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  // Future<void> _logout(BuildContext context) async {
  //   // Clear shared preferences if needed
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear(); // Clear all stored data.
  //   prefs.remove('is_logged_in');

  //   // Sign out from Firebase
  //   FirebaseAuth.instance.signOut();

  //   Provider.of<MainContainerViewModel>(context, listen: false).setIndex(0);

  //   // Navigate to SplashScreen or MainContainer, clearing the navigation stack
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => SplashScreen()),
  //     (route) => false, // Remove all previous routes
  //   );
  // }

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

    // Reset any provider state or other application states
    Provider.of<MainContainerViewModel>(context, listen: false).setIndex(0);

    // Navigate to SplashScreen or MainContainer, clearing the navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SplashScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog.
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog.
                _logout(context); // Perform logout.
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
