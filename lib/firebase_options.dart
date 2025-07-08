// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHz6-0q6DEzGSxo37wHMX5KLNltijdPjQ',
    appId: '1:260017866209:android:c4984aabd4390320f0fea0',
    messagingSenderId: '260017866209',
    projectId: 'notesapp-a9439',
    storageBucket: 'notesapp-a9439.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHz6-0q6DEzGSxo37wHMX5KLNltijdPjQ',
    appId: '1:260017866209:android:c4984aabd4390320f0fea0',
    messagingSenderId: '260017866209',
    projectId: 'notesapp-a9439',
    storageBucket: 'notesapp-a9439.firebasestorage.app',
    iosBundleId: 'com.comapany.notesapp',
  );

  // If you need macOS
  static const FirebaseOptions macos = ios;

  // If you’re actually using web, fill in your own web keys here:
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHkAOtSes9-9FEfY1mnB4R4VcYu2jAcEY',
    authDomain: 'notes-d4f24.firebaseapp.com',
    projectId: 'notes-d4f24',
    storageBucket: 'notes-d4f24.firebasestorage.app',
    messagingSenderId: '997695311497',
    appId: '1:997695311497:web:574908621f4624c8850058',
    measurementId: 'G-K6XN8JY7K1',
  );
}
