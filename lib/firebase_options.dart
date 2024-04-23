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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9JALhu991nlYFaYUzLhR1wxWb8nsEIgE',
    appId: '1:248024865261:android:120b2e0c521f7aa870afe4',
    messagingSenderId: '248024865261',
    projectId: 'micromitti-68ea0',
    storageBucket: 'micromitti-68ea0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeIl_V80SjY3TySghOkFFeIBUcuZ3bKx4',
    appId: '1:248024865261:ios:9c75c37eae126c9f70afe4',
    messagingSenderId: '248024865261',
    projectId: 'micromitti-68ea0',
    storageBucket: 'micromitti-68ea0.appspot.com',
    androidClientId: '248024865261-0m7qd1379unfu5ml1175mudj4mm9cl3t.apps.googleusercontent.com',
    iosClientId: '248024865261-5bgmq2lsne8ad7detggcli8vbfbs54e6.apps.googleusercontent.com',
    iosBundleId: 'com.MicroMitti.micromitti',
  );
}
