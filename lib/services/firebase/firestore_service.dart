import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gp5/config/log.dart';
import 'package:flutter_gp5/models/user.dart';
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
      'userType': user.userType.name
    });
  }

  Future<User?> getCurrentUser() async {
    try {
      final currentUser = FirebaseService.auth.currentUser;
      if (currentUser == null) {
        Log.error('No authenticated user found.');
        return null;
      }

      final userRef = _firestore.collection(_users).doc(currentUser.uid);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        Log.error('No user document found for UID: ${currentUser.uid}');
        return null;
      }

      final userData = userSnapshot.data();
      if (userData == null) {
        Log.error('User document exists but contains no data.');
        return null;
      }

      final userDetails = User.fromJson(userData);

      return User(
        id: currentUser.uid,
        email: currentUser.email ?? 'missing email',
        name: userDetails.name,
        phone: userDetails.phone,
        userType: userDetails.userType,
        workplace: userDetails.workplace,
      );
    } catch (e) {
      Log.error('Error fetching user data: $e');
      return null;
    }
  }
}
