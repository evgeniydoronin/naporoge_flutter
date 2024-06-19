// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAor91vbbOv8io9lUhNdBaHrWuo88X6Rus',
    appId: '1:79468427448:web:625ff8a0e48efd9a129c4d',
    messagingSenderId: '79468427448',
    projectId: 'naporoge-cf9be',
    authDomain: 'naporoge-cf9be.firebaseapp.com',
    storageBucket: 'naporoge-cf9be.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbm7g6_X_20tPdISEKkij0B6sQqnhaj88',
    appId: '1:79468427448:android:8994df842f3fcbbe129c4d',
    messagingSenderId: '79468427448',
    projectId: 'naporoge-cf9be',
    storageBucket: 'naporoge-cf9be.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu30lyPUqJ_nIFaWYGKCRszMv6MmWiLlw',
    appId: '1:79468427448:ios:c4a35ce332cb346d129c4d',
    messagingSenderId: '79468427448',
    projectId: 'naporoge-cf9be',
    storageBucket: 'naporoge-cf9be.appspot.com',
    iosBundleId: 'ru.naporoge.umadmin2',
  );
}
