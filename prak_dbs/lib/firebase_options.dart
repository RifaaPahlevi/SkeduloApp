import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAeaCdb9wVKxi-NkFfXRTaO_8inaSZXJ0g',
    appId: '1:758209360118:web:8b6ae07a1ca2ab3f927cd7',
    messagingSenderId: '758209360118',
    projectId: 'prak-dbs1',
    authDomain: 'prak-dbs1.firebaseapp.com',
    storageBucket: 'prak-dbs1.firebasestorage.app',
    measurementId: 'G-DE57081LZN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOeLEMRTAUFFZ6Yy-cyfq3JhMYMJAGUbs',
    appId: '1:758209360118:android:86b90180f5e73175927cd7',
    messagingSenderId: '758209360118',
    projectId: 'prak-dbs1',
    storageBucket: 'prak-dbs1.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAeaCdb9wVKxi-NkFfXRTaO_8inaSZXJ0g',
    appId: '1:758209360118:web:5427dd0cd82e2270927cd7',
    messagingSenderId: '758209360118',
    projectId: 'prak-dbs1',
    authDomain: 'prak-dbs1.firebaseapp.com',
    storageBucket: 'prak-dbs1.firebasestorage.app',
    measurementId: 'G-JDPBDNXGSD',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQmifD00MHOzZWqgV25SIltt83Zk8u-Q8',
    appId: '1:758209360118:ios:c59a1d3a0b8861fc927cd7',
    messagingSenderId: '758209360118',
    projectId: 'prak-dbs1',
    storageBucket: 'prak-dbs1.firebasestorage.app',
    iosBundleId: 'com.maul.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQmifD00MHOzZWqgV25SIltt83Zk8u-Q8',
    appId: '1:758209360118:ios:bde0762de8ab3658927cd7',
    messagingSenderId: '758209360118',
    projectId: 'prak-dbs1',
    storageBucket: 'prak-dbs1.firebasestorage.app',
    iosBundleId: 'com.example.app',
  );

}