import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gp5/config/log.dart';
import 'package:flutter_gp5/enums/authentication.dart';
import 'package:flutter_gp5/services/firebase/firebase_service.dart';
import 'package:flutter_gp5/services/firebase/firestore_service.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseService.auth;

  final StreamController<Authentication> _controller =
  StreamController<Authentication>.broadcast();
  late final StreamSubscription<User?> _authStateSubscription;

  AuthenticationRepository() {
    // Listen to authentication state changes and handle them with _authStateListener.
    _authStateSubscription =
        _firebaseAuth.authStateChanges().listen(_authStateListener);
  }

  // Expose a stream of authentication statuses.
  Stream<Authentication> get status => _controller.stream;

  // Handle authentication state changes.
  void _authStateListener(User? user) {
    if (user != null) {
      _controller.add(Authentication.authenticated);
      Log.info('User authenticated: ${user.email}');
    } else {
      _controller.add(Authentication.unauthenticated);
      Log.info('User unauthenticated');
    }
  }

  Future<void> login({required String email, required String password}) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'error-null-user');
    }
  }

  Future<void> register({required String email, required String password}) async {
    UserCredential userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredentials.user;
    if (user == null) {
      throw FirebaseAuthException(code: 'error-null-user');
    }

    await FirestoreService.instance.createOrUpdateUser(user);
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _controller.add(Authentication.unauthenticated);
      Log.info('User logged out successfully');
    } catch (error) {
      Log.error('Failed to log out: $error');
      throw Exception('Logout failed');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  void dispose() {
    _authStateSubscription.cancel();
    _controller.close();
  }
}