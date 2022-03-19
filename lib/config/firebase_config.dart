import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions? get platformOptions {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyDMxf-rNUOxlQHs3kQ2SYcfoiW7XT-8XAQ",
          authDomain: "sparktvshowreminder.firebaseapp.com",
          databaseURL: "https://sparktvshowreminder-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "sparktvshowreminder",
          storageBucket: "sparktvshowreminder.appspot.com",
          messagingSenderId: "555956113257",
          appId: "1:555956113257:web:31b4c1f25faa3a013977f8",
          measurementId: "G-4LEE9CJ1KE");
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:555956113257:ios:a7513d10b51c47bf3977f8',
        apiKey: 'AIzaSyAP9On9U95y6XajQ_Kb7qqvv1i-1IGF2s4',
        projectId: 'sparktvshowreminder',
        messagingSenderId: '555956113257',
        iosBundleId: 'spark-tv-shows',
        iosClientId:
            '555956113257-5n59s4dft5jv9ulc767j2scdhfgrem00.apps.googleusercontent.com',
        androidClientId:
            '555956113257-5n59s4dft5jv9ulc767j2scdhfgrem00.apps.googleusercontent.com',
        databaseURL: 'https://sparktvshowreminder-default-rtdb.asia-southeast1.firebasedatabase.app',
        storageBucket: 'sparktvshowreminder.appspot.com',
      );
    } else {
      // Android
      log("Analytics Dart-only initializer doesn't work on Android, please make sure to add the config file.");

      return null;
    }
  }
}
