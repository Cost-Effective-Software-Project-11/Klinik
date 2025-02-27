import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_gp5/config/log.dart';
import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/models/user.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'firebase_service.dart';

class FirestoreService {
  // Private constructor
  FirestoreService._();

  // Singleton instance
  static final FirestoreService instance = FirestoreService._();

  static final FirebaseFirestore _firestore = FirebaseService.firestore;

  // collections
  static const String _users = 'users';

  Future<void> createOrUpdateUser(User user) async {
    await _firestore.collection(_users).doc(user.id).set({
      'uid': user.id,
      'name': user.name,
      'email': user.email,
      'workplace': user.workplace.toJson(),
      'phone': user.phone,
      'createdAt': FieldValue.serverTimestamp(),
      'changedAt': FieldValue.serverTimestamp(),
    });
  }

  User? getCurrentUser() {
    try {
      final currentUser = FirebaseService.auth.currentUser;
      if (currentUser != null) {
        return User(
          id: currentUser.uid,
          email: currentUser.email ?? '',
          name: currentUser.displayName ?? '',
          phone: '',
          speciality: '',
          type: UserType.doctor,
          workplace: const Workplace(name: '', city: 'city'),
        );
      }
    } catch (e) {
      Log.error('Error getting current user: $e');
    }
    return null;
  }
}
