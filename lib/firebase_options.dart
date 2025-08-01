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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA20BuJkhET0QFUsy_X5kecXbYnP-ERYfs',
    appId: '1:722131854046:android:2b8e9b35426896d8ce584f',
    messagingSenderId: '722131854046',
    projectId: 'yuhaian',
    storageBucket: 'yuhaian.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDePe6e4_o23258aTqelWBkkQmgQuldvnk',
    appId: '1:722131854046:web:9d48008fe21474ffce584f',
    messagingSenderId: '722131854046',
    projectId: 'yuhaian',
    authDomain: 'yuhaian.firebaseapp.com',
    storageBucket: 'yuhaian.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDePe6e4_o23258aTqelWBkkQmgQuldvnk',
    appId: '1:722131854046:web:65e7e550f92d7526ce584f',
    messagingSenderId: '722131854046',
    projectId: 'yuhaian',
    authDomain: 'yuhaian.firebaseapp.com',
    storageBucket: 'yuhaian.firebasestorage.app',
  );

}