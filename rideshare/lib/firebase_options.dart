// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAtx3pEaz7VIHOuB0fSzaVIZ8kM-WZPeA8',
    appId: '1:227986971808:web:92a22150e2a665ee09bdc5',
    messagingSenderId: '227986971808',
    projectId: 'rideshare-cdad7',
    authDomain: 'rideshare-cdad7.firebaseapp.com',
    storageBucket: 'rideshare-cdad7.appspot.com',
    measurementId: 'G-RH17NDYZ3Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3STVV60TL7AUvYB6XqRWeV1U2Oi9QDUA',
    appId: '1:227986971808:android:892dc0683768959909bdc5',
    messagingSenderId: '227986971808',
    projectId: 'rideshare-cdad7',
    storageBucket: 'rideshare-cdad7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCC-8HPZTpOxR0xy95Fd9H4AtDcjf-28PM',
    appId: '1:227986971808:ios:4361fd5f235a42a409bdc5',
    messagingSenderId: '227986971808',
    projectId: 'rideshare-cdad7',
    storageBucket: 'rideshare-cdad7.appspot.com',
    iosClientId: '227986971808-aqtcie3k91uf3e0li163kms7tm1c2a65.apps.googleusercontent.com',
    iosBundleId: 'com.example.rideshare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCC-8HPZTpOxR0xy95Fd9H4AtDcjf-28PM',
    appId: '1:227986971808:ios:4361fd5f235a42a409bdc5',
    messagingSenderId: '227986971808',
    projectId: 'rideshare-cdad7',
    storageBucket: 'rideshare-cdad7.appspot.com',
    iosClientId: '227986971808-aqtcie3k91uf3e0li163kms7tm1c2a65.apps.googleusercontent.com',
    iosBundleId: 'com.example.rideshare',
  );
}
