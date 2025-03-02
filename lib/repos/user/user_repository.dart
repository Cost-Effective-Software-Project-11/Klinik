import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../models/user.dart';
import '../../screens/home/bloc/models/detailed_doctor_model.dart';

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
        //return User.fromMap(doc.data());
        return null;
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

  // Asynchronous method to fetch a doctor by ID, returning a nullable User
  Future<DoctorDetail?> getDoctorDetail(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return DoctorDetail.fromMap(doc.data()!);
      } else {
        _logger.w('Doctor with id $id does not exist or data is null.');
      }
    } on FirebaseException catch (e) {
      _logger.e('FirebaseException: ${e.message}', error: e);
    } catch (e, stack) {
      _logger.e('Exception while fetching doctor details: $e', error: e, stackTrace: stack);
    }
    return null;
  }

  Future<List<User>> getUsersInChatWith(String currentUserId) async {
    List<User> userList = [];
    try {
      // Query chat_rooms where currentUserId is a participant
      final chatRoomCollection = await _firestore
          .collection("chat_rooms")
          .where('participants', arrayContains: currentUserId)
          .get();

      // Extract the userIds of the other participants
      Set<String> participantIds = {};

      for (var element in chatRoomCollection.docs) {
        List<dynamic> participants = element.data()['participants'];
        for (var participantId in participants) {
          if(participantId!=currentUserId)
            {
              participantIds.add(participantId);
            }
        }
      }

      // Query the users collection to get the users with the participantIds
      if (participantIds.isNotEmpty) {
        final userCollection = await _firestore
            .collection("users")
            .where(FieldPath.documentId, whereIn: participantIds.toList())
            .get();

        // Convert documents to User objects
        // userCollection.docs.forEach((element) {
        //   //final user = User.fromMap(element.data());
        //   final user = User();
        //   final userWithId = User(
        //     id: element.id,
        //     email: user.email,
        //     name: user.name,
        //     phone: user.phone,
        //     speciality: user.speciality,
        //     type: user.type,
        //     workplace: user.workplace,
        //   );
        //   userList.add(userWithId);
        // });
      }
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
