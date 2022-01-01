// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDn1K8dUCUF50DRIJUJb6g5GNB1nFSoK2A',
    appId: '1:744930124972:web:307bb6b8bfbc9883d9eb09',
    messagingSenderId: '744930124972',
    projectId: 'snapkart-3d80d',
    authDomain: 'snapkart-3d80d.firebaseapp.com',
    storageBucket: 'snapkart-3d80d.appspot.com',
    measurementId: 'G-7D4YPK6W03',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzrnKARk2T8MS0q6rSG6E19h485Zh6t3Q',
    appId: '1:744930124972:android:b7e9eeb7fed2f541d9eb09',
    messagingSenderId: '744930124972',
    projectId: 'snapkart-3d80d',
    storageBucket: 'snapkart-3d80d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1HL9ymG82UOJ1FznXMheGrKOKzIHIUQ4',
    appId: '1:744930124972:ios:c3fda8eff76c4b72d9eb09',
    messagingSenderId: '744930124972',
    projectId: 'snapkart-3d80d',
    storageBucket: 'snapkart-3d80d.appspot.com',
    iosClientId: '744930124972-guafpme2n4bgf74929m7ihdqu4hgp5kb.apps.googleusercontent.com',
    iosBundleId: 'com.example.grokart',
  );
}
