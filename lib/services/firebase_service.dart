import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

/// Starts Firebase once at app launch using FlutterFire options.
class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
