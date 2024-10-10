import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gp5/models/chat_room_model.dart';
import 'package:flutter_gp5/models/message_model.dart';
import 'package:logger/logger.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  ChatRepository({
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  Future<String?> createChatRoom(ChatRoomModel chatRoom) async {
    try {
      // Check if a chat room with these participants already exists
      final searchedChatRoom =
          await findChatRoomId(participants: chatRoom.participants);

      // If there are no existing chat rooms, create a new one
      if (searchedChatRoom == null) {
        final chatRoomModel = ChatRoomModel(
          lastMessage: chatRoom.lastMessage,
          participants: chatRoom.participants,
          timestamp: chatRoom.timestamp,
        );

        // Convert the ChatRoomModel to a Map and add it to Firestore
        DocumentReference docRef = await _firestore
            .collection('chat_rooms')
            .add(chatRoomModel.toMap());

        // Retrieve the generated chatId and log the success
        String chatId = docRef.id;

        _logger.i('Chat room $chatId created successfully.');
        return chatId;
      } else {
        _logger.i('Chat room already exists.');
        return searchedChatRoom;
      }
    } catch (e) {
      _logger.e('Error creating chat room: $e', error: e);
    }
    return null;
  }

  Future<void> updateChatRoomLastMessageAndTimeStamp({
    required String chatRoomId,
    required String messageContent,
    required Timestamp lastMessageTimestamp,
  }) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).update({
        'lastMessage': messageContent,
        'lastMessageTimestamp': lastMessageTimestamp,
      });
      _logger.i('Chat room $chatRoomId updated successfully.');
    } catch (e) {
      _logger.e('Error updating chat room $chatRoomId: $e', error: e);
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      // Ensure senderId and receiverId are not null
      final senderId = message.senderId;
      final receiverId = message.receiverId;

      if (senderId == null) {
        _logger.e('Error: senderId or receiverId is null');
        return; // Exit the function early
      }
      // Proceed with finding the chat room ID
      final chatRoomId =
          await findChatRoomId(participants: [senderId, receiverId]);

      if (chatRoomId == null) {
        _logger.e('Error chat room not found');
      } else {
        // Create message data
        final messageData = message.toMap();

        // Add the message to the sub-collection
        await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .add(messageData);

        // Update last message and timestamp in the chat room
        await updateChatRoomLastMessageAndTimeStamp(
          chatRoomId: chatRoomId,
          messageContent: message.messageContent,
          lastMessageTimestamp: message.timestamp,
        );

        _logger.i('Message sent in chat room $chatRoomId.');
      }
    } catch (e) {
      _logger.e('Error sending message in chat room: $e', error: e);
    }
  }

  Stream<List<Message>> getMessagesStream(
      String currentUserId,
      String chatParticipantTwoId,
      ) async* {
    try {
      int limit = 15;
      final chatRoomId = await findChatRoomId(
        participants: [currentUserId, chatParticipantTwoId],
      );

      if (chatRoomId == null) {
        _logger.e('No chat room found for participants $currentUserId and $chatParticipantTwoId.');
        yield [];
        return;
      }
      Query query = _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      await for (var snapshot in query.snapshots()) {
        List<Message> messages = snapshot.docs.map((doc) {
          return Message.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        List<Message> unreadMessages = messages.where((message) =>
        message.receiverId == currentUserId && !message.isRead).toList();


        if (unreadMessages.isNotEmpty) {
          WriteBatch batch = _firestore.batch();

          for (var message in unreadMessages) {
            DocumentReference messageRef = _firestore
                .collection('chat_rooms')
                .doc(chatRoomId)
                .collection('messages')
                .doc(message.messageId);

            batch.update(messageRef, {'isRead': true});
          }

          await batch.commit();
        }
        yield messages;
      }
    } catch (e) {
      _logger.e('Error fetching messages stream: $e', error: e);
      yield [];
    }
  }

  Future<List<Message>> getMoreMessages({
    required String currentUserId,
    required String chatParticipantTwoId,
    required Message lastMessage,
    int limit = 15,
  }) async {
    try {
      _logger.d(
          'Fetching more messages for chat between $currentUserId and $chatParticipantTwoId.');

      final chatRoomId = await findChatRoomId(
        participants: [currentUserId, chatParticipantTwoId],
      );

      if (chatRoomId == null) {
        _logger.e(
            'No chat room found for participants $currentUserId and $chatParticipantTwoId.');
        return [];
      }

      _logger.d(
          'Chat room ID found: $chatRoomId. Fetching messages after timestamp: ${lastMessage.timestamp.toDate()}');

      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .startAfter([lastMessage.timestamp])
          .limit(limit)
          .get();

      List<Message> messages = querySnapshot.docs.map((doc) {
        return Message.fromMap(doc.data(), doc.id);
      }).toList();

      // Mark unread messages as read if the current user is the receiver
      List<Message> unreadMessages = messages.where((message) =>
      message.receiverId == currentUserId && !message.isRead).toList();

      if (unreadMessages.isNotEmpty) {
        WriteBatch batch = _firestore.batch();

        for (var message in unreadMessages) {
          DocumentReference messageRef = _firestore
              .collection('chat_rooms')
              .doc(chatRoomId)
              .collection('messages')
              .doc(message.messageId);

          batch.update(messageRef, {'isRead': true});
        }

        await batch.commit();
        _logger.d('Marked ${unreadMessages.length} messages as read.');
      }

      _logger.d('Fetched ${messages.length} more messages.');
      return messages;
    } catch (e) {
      _logger.e('Error fetching more messages: $e', error: e);
      return [];
    }
  }


  Future<String?> findChatRoomId({required List<String> participants}) async {
    try {
      // Ensure we have exactly two participants to compare
      if (participants.length != 2) {
        throw ArgumentError(
            'Participants list must contain exactly two participants.');
      }

      // Fetch potential chat rooms where the participants list contains either of the IDs
      QuerySnapshot querySnapshot = await _firestore
          .collection('chat_rooms')
          .where('participants', arrayContainsAny: participants)
          .get();

      // Filter results to find a chat room where both participants are present
      for (var doc in querySnapshot.docs) {
        List<String> chatRoomParticipants =
            List<String>.from(doc['participants']);

        // Check if both participants are present in the chat room's participants list
        if (participants.every(
            (participant) => chatRoomParticipants.contains(participant))) {
          // Return the ID of the matching document
          return doc.id;
        }
      }

      // Return null if no matching chat room is found
      return null;
    } catch (e) {
      // Log or handle the error
      print('Error finding chat room: $e');
      return null;
    }
  }

  Future<Message?> getLastMessageFromChatRoom(String currentUserId,String chatPartnerId) async {
    try {
      final chatRoomId=await findChatRoomId(participants: [currentUserId, chatPartnerId]);

       final chatRoomDoc = await _firestore.collection('chat_rooms').doc(chatRoomId).get();

      if (chatRoomDoc.exists) {
        final messagesSnapshot = await _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        // Check if there are any messages
        if (messagesSnapshot.docs.isNotEmpty) {
          // Get the first (most recent) message document
          final lastMessageDoc = messagesSnapshot.docs.first;

          // Get the document data and the document ID (messageId)
          final lastMessageData = lastMessageDoc.data();
          final messageId = lastMessageDoc.id;  // This is the doc ID

          // Convert the message data into a Message model with messageId
          return Message.fromMap(lastMessageData, messageId);
        }
      }

    } on FirebaseException catch (e) {
      _logger.e('FirebaseException: ${e.message}', error: e);
    } catch (e, stack) {
      _logger.e('Exception while fetching last message: $e', error: e, stackTrace: stack);
    }

    return null;
  }

  Future<int> getUnreadMessagesCount(String currentUserId, String chatPartnerId) async {
    try {
      // Find the chat room between the current user and chat partner
      final chatRoomId = await findChatRoomId(
        participants: [currentUserId, chatPartnerId],
      );

      if (chatRoomId == null) {
        _logger.e('No chat room found for participants $currentUserId and $chatPartnerId.');
        return 0;
      }
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('senderId', isEqualTo: chatPartnerId)
          .where('isRead', isEqualTo: false)
          .limit(3)
          .get();

      final unreadMessagesCount = querySnapshot.docs.length;

      // If the count is greater than 2, return 3 (because we want at most 3)
      return unreadMessagesCount > 2 ? 3 : unreadMessagesCount;
    } catch (e) {
      _logger.e('Error fetching unread message count: $e', error: e);
      return 0;
    }
  }

}
