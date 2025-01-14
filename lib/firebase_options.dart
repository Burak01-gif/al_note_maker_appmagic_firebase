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
    apiKey: 'AIzaSyCZGHlA3B1Oqi0bC1dUBL00-xkbTCy3e7w',
    appId: '1:1004556392474:web:aa46b4260e06fc74d4d9a3',
    messagingSenderId: '1004556392474',
    projectId: 'appmagic-firebase',
    authDomain: 'appmagic-firebase.firebaseapp.com',
    storageBucket: 'appmagic-firebase.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCMCODRPrAw9tROevHU37k23MPsMaJE5mI',
    appId: '1:1004556392474:android:aaec7c6e4d781348d4d9a3',
    messagingSenderId: '1004556392474',
    projectId: 'appmagic-firebase',
    storageBucket: 'appmagic-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKupROBDWfzYk0hkXJO20aTHrVKQaQb9o',
    appId: '1:1004556392474:ios:99774671a496b606d4d9a3',
    messagingSenderId: '1004556392474',
    projectId: 'appmagic-firebase',
    storageBucket: 'appmagic-firebase.firebasestorage.app',
    iosBundleId: 'com.example.alNoteMakerAppmagic',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKupROBDWfzYk0hkXJO20aTHrVKQaQb9o',
    appId: '1:1004556392474:ios:99774671a496b606d4d9a3',
    messagingSenderId: '1004556392474',
    projectId: 'appmagic-firebase',
    storageBucket: 'appmagic-firebase.firebasestorage.app',
    iosBundleId: 'com.example.alNoteMakerAppmagic',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCZGHlA3B1Oqi0bC1dUBL00-xkbTCy3e7w',
    appId: '1:1004556392474:web:66106179579e3034d4d9a3',
    messagingSenderId: '1004556392474',
    projectId: 'appmagic-firebase',
    authDomain: 'appmagic-firebase.firebaseapp.com',
    storageBucket: 'appmagic-firebase.firebasestorage.app',
  );
}
