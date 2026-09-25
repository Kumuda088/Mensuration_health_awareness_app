import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service.dart';

/// Email and password authentication with Firebase.
class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    FirestoreService? firestoreService,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _firestoreService = firestoreService ?? FirestoreService();

  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<UserCredential> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name.trim());

    final uid = credential.user?.uid;
    if (uid != null) {
      await _firestoreService.createUserDocument(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
      );
    }

    return credential;
  }

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await user.updateDisplayName(name.trim());
    await user.reload();
    await _firestoreService.updateUserName(
      uid: user.uid,
      name: name.trim(),
    );
  }

  /// Converts Firebase Auth errors into short messages for the UI.
  static String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Check your internet connection.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
