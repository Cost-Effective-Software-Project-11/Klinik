import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  // Dependency injection of Firestore and Logger for better testability
  UserRepository({
    FirebaseFirestore? firestore,
    Logger? logger,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  // Asynchronous method to fetch a user by ID, returning a nullable User
  Future<User?> getUser(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists && doc.data() != null) {
        // Safely parse the user using the refactored fromMap method
        return User.fromMap(doc.data());
      } else {
        _logger.w('User with id $id does not exist or data is null.');
      }
    } on FirebaseException catch (e) {
      _logger.e('FirebaseException: ${e.message}', error: e);
    } catch (e, stack) {
      _logger.e('Exception while fetching user: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  Future<List<User>> getAll() async {
    List<User> userList = [];
    try {
      final userCollection =
          await FirebaseFirestore.instance.collection("users").get();
      userCollection.docs.forEach((element) {
        return userList.add(User.fromMap(element.data()));
      });
      return userList;
    } on FirebaseException catch (e) {
      _logger.e('FirebaseException: ${e.message}', error: e);
    } catch (e, stack) {
      _logger.e('Exception while fetching users: $e',
          error: e, stackTrace: stack);
    }
    return userList;
  }
}
