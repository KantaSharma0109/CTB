// import 'package:flutter/material.dart';
// import 'package:chef_taruna_birla/pages/login/signin.dart';
// import 'package:chef_taruna_birla/pages/login/signup.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../main_container.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late AnimationController slideAnimation;
//   late Animation<Offset> offsetAnimation;
//   late Animation<Offset> textAnimation;

//   // Future<void> getAppData() async {
//   //   Provider.of<MainContainerViewModel>(context, listen: false)
//   //       .getAppData(context);

//   //   // Future.delayed(const Duration(seconds: 3), () {
//   //   //   Navigator.pushReplacement(
//   //   //     context,
//   //   //     MaterialPageRoute(
//   //   //       builder: (context) => const MainContainer(),
//   //   //     ),
//   //   //   );
//   //   // });
//   // }

//   @override
//   void initState() {
//     animationController = AnimationController(
//       vsync: this,
//       lowerBound: 0,
//       upperBound: 60,
//       animationBehavior: AnimationBehavior.normal,
//       duration: const Duration(milliseconds: 700),
//     );

//     animationController.forward();

//     slideAnimation = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     offsetAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(0.0, 0.0),
//     ).animate(
//       CurvedAnimation(
//         parent: slideAnimation,
//         curve: Curves.easeInToLinear,
//       ),
//     );

//     textAnimation = Tween<Offset>(
//       begin: const Offset(-0.5, 0.0),
//       end: const Offset(0.2, 0.0),
//     ).animate(
//       CurvedAnimation(
//         parent: slideAnimation,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );

//     animationController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         slideAnimation.forward();
//       }
//     });
//     // getAppData();
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

//     // Delay the splash screen for a few seconds
//     await Future.delayed(const Duration(seconds: 3));

//     // Navigate based on login status
//     if (isLoggedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MainContainer()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SignInScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           //   Container(
//           //     color: Palette.black,
//           //     width: double.infinity,
//           //     height: double.infinity,
//           //     child: Center(
//           //       child: AnimatedBuilder(
//           //         animation: animationController,
//           //         builder: (_, child) {
//           //           return SlideTransition(
//           //             position: offsetAnimation,
//           //             child: Image.asset(
//           //               'assets/images/tb_splash_img.png',
//           //               height: double.infinity,
//           //               fit: BoxFit.cover,
//           //               alignment: Alignment.center,
//           //             ),
//           //           );
//           //         },
//           //       ),
//           //     ),
//           //   ),
//           // );
//           Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: AnimatedBuilder(
//               animation: animationController,
//               builder: (_, child) {
//                 return SlideTransition(
//                   position: offsetAnimation,
//                   child: Image.asset(
//                     'assets/images/tb_splash_img.png',
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     alignment: Alignment.center,
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Sign In Button and Text at the Bottom
//           Positioned(
//             bottom: 40.0,
//             left: 16.0, // Add padding on the left
//             right: 16.0, // Add padding on the right
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SignInScreen()),
//                       );
//                       // Navigate to sign-in screen or perform sign-in action
//                       print("Sign In button pressed");
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           const Color(0xFFD68D54), // Set button color to D68D54
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                     child: const Text(
//                       "Sign In",
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors
//                             .white, // Set text color to white for contrast
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 // "Don't have an account? Sign Up" Text
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don’t have an account?",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.0,
//                       ),
//                     ),
//                     const SizedBox(width: 5.0),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SignUpScreen()),
//                         );

//                         print("Sign In button pressed");
//                       },
//                       child: const Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           color: Color(0xFFD68D54),
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:chef_taruna_birla/pages/login/signin.dart';
import 'package:chef_taruna_birla/pages/login/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  bool _isLoggedIn = false; // Track login status
  bool _isCheckingInternet = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInToLinear,
      ),
    );

    animationController.forward();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        _isConnected = true;
      });
      _checkLoginStatus();
    } else {
      setState(() {
        _isConnected = false;
      });
      _waitForInternetConnection();
    }
  }

  Future<void> _waitForInternetConnection() async {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Check if any of the results indicate a valid connection
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        setState(() {
          _isConnected = true;
        });
        _checkLoginStatus();
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    setState(() {
      _isLoggedIn = isLoggedIn;
    });

    // Delay the splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      // Navigate to MainContainer if user is already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainContainer()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (_, child) {
                return SlideTransition(
                  position: offsetAnimation,
                  child: Image.asset(
                    'assets/images/splash.jpeg',
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                );
              },
            ),
          ),
          // Show Sign In button only if user is not logged in and internet is connected
          if (!_isLoggedIn && _isConnected)
            Positioned(
              bottom: 40.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Open SignInScreen directly without showing it inside SplashScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD68D54),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Sign Up option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFD68D54),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Show a message if internet is not connected
          if (!_isConnected)
            Positioned(
              // bottom: 100.0,
              // left: 16.0,
              // right: 16.0,
              child: Center(
                child: Text(
                  "Please turn on mobile data or Wi-Fi to continue",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
