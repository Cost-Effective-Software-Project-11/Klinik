import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gp5/config/log.dart';
import 'package:flutter_gp5/enums/authentication.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'package:flutter_gp5/services/firebase/firebase_service.dart';
import 'package:flutter_gp5/services/firebase/firestore_service.dart';
import 'package:flutter_gp5/models/user.dart' as user_model;

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

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Workplace workplace,
    required UserType userType,
  }) async {
    User? user;

    try {
      UserCredential userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredentials.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'error-null-user',
          message: 'User creation failed.',
        );
      }

      user_model.User userModel = user_model.User(
        id: user.uid,
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        workplace: workplace,
      );

      await FirestoreService.instance.createOrUpdateUser(userModel);
    } catch (error) {
      Log.error('Error during user registration: $error');
      if (user != null) {
        try {
          await user.delete();
          Log.error('Rollback: Firebase user deleted.');
        } catch (deleteError) {
          Log.error(
              'Rollback failed: Unable to delete Firebase user - $deleteError');
        }
      }
      rethrow;
    }
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