import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../../enums/authentication_status_enum.dart';

// Define the authentication status as an enumeration.
enum _AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth; // Instance of FirebaseAuth.
  final FirebaseFirestore _firestore; // Instance of FirebaseFirestore.
  // StreamController to handle the authentication status updates.
  final StreamController<_AuthenticationStatus> _controller = StreamController<_AuthenticationStatus>();
  final Logger _logger;

  // Constructor with optional parameters for FirebaseAuth and FirebaseFirestore.
  AuthenticationRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger(){
    // Listen to the auth state changes and update the stream accordingly.
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _controller.add(_AuthenticationStatus.authenticated);
      } else {
        _controller.add(_AuthenticationStatus.unauthenticated);
      }
    });
  }

  // Stream that provides continuous updates on the authentication status.
  Stream<AuthenticationStatus> get status {
    // Ensure this stream emits AuthenticationStatus
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? AuthenticationStatus.authenticated : AuthenticationStatus.unauthenticated;
    });
  }


  // Get the current user.
  User? get currentUser => _firebaseAuth.currentUser;

  // Method to log in a user using a username and password.
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _controller.add(_AuthenticationStatus.authenticated);
    } catch (e) {
      _logger.e('Login error:', error: e);
      _controller.add(_AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  // Method to sign up a new user.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String specialty,
    required String type,
    required String workplace,
  }) async {
    try {
      // Step 1: Create user with email and password.
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Store user information in Firestore in the 'users' collection.
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'speciality': specialty,
        'type': type,
        'workplace': workplace,
      });
      _controller.add(_AuthenticationStatus.authenticated);
    } catch (e) {
      _logger.e('Signup error:', error: e);
      _controller.add(_AuthenticationStatus.unauthenticated);
      rethrow;
    }
  }

  // Method to check if user is currently logged in.
  bool isLoggedIn() {
    var isLoggedIn = _firebaseAuth.currentUser != null;
    return isLoggedIn;
  }

  // Method to log out the current user.
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    _controller.add(_AuthenticationStatus.unauthenticated);
  }

  // Dispose method to close the StreamController when done.
  void dispose() => _controller.close();
}
