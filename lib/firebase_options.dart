// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD6VKqE5GbAh-koQA0oYFjrqSGDjTemI7A',
    appId: '1:753457259745:web:1a1f8186381b73e9b7c3a0',
    messagingSenderId: '753457259745',
    projectId: 'tarunabirla-ef977',
    authDomain: 'tarunabirla-ef977.firebaseapp.com',
    databaseURL: 'https://tarunabirla-ef977-default-rtdb.firebaseio.com',
    storageBucket: 'tarunabirla-ef977.appspot.com',
    measurementId: 'G-2JV0NXV7XL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBV0qQlbjCyFbLEsc2BicaHHXqoN6tCqE',
    appId: '1:753457259745:android:cbb659dbb56c36d5b7c3a0',
    messagingSenderId: '753457259745',
    projectId: 'tarunabirla-ef977',
    databaseURL: 'https://tarunabirla-ef977-default-rtdb.firebaseio.com',
    storageBucket: 'tarunabirla-ef977.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOr63lzxZvW01qKwVZvjiFAlS7KFev3hQ',
    appId: '1:753457259745:ios:c5d5c2e145bd1e3cb7c3a0',
    messagingSenderId: '753457259745',
    projectId: 'tarunabirla-ef977',
    databaseURL: 'https://tarunabirla-ef977-default-rtdb.firebaseio.com',
    storageBucket: 'tarunabirla-ef977.appspot.com',
    androidClientId: '753457259745-c2tuof4neqovn7d652ug0ftv13kut15o.apps.googleusercontent.com',
    iosClientId: '753457259745-ai1tee85oe33av9jbo7uodu2ou2qbfqm.apps.googleusercontent.com',
    iosBundleId: 'com.cheftarunbirla',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOr63lzxZvW01qKwVZvjiFAlS7KFev3hQ',
    appId: '1:753457259745:ios:9d52b5aca464fd85b7c3a0',
    messagingSenderId: '753457259745',
    projectId: 'tarunabirla-ef977',
    databaseURL: 'https://tarunabirla-ef977-default-rtdb.firebaseio.com',
    storageBucket: 'tarunabirla-ef977.appspot.com',
    androidClientId: '753457259745-c2tuof4neqovn7d652ug0ftv13kut15o.apps.googleusercontent.com',
    iosClientId: '753457259745-3vba0jpff7hk54f2lamtg1v1d2s13dop.apps.googleusercontent.com',
    iosBundleId: 'com.example.chefTarunaBirla',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6VKqE5GbAh-koQA0oYFjrqSGDjTemI7A',
    appId: '1:753457259745:web:872fef777fd0bcc1b7c3a0',
    messagingSenderId: '753457259745',
    projectId: 'tarunabirla-ef977',
    authDomain: 'tarunabirla-ef977.firebaseapp.com',
    databaseURL: 'https://tarunabirla-ef977-default-rtdb.firebaseio.com',
    storageBucket: 'tarunabirla-ef977.appspot.com',
    measurementId: 'G-HMCVCSXPTK',
  );
}
