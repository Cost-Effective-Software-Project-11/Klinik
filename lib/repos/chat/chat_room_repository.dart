import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gp5/models/chat_room_model.dart';
import 'package:flutter_gp5/models/message_model.dart';
import 'package:logger/logger.dart';

class ChatRoomRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  ChatRoomRepository({
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  Future<void> createChatRoom(ChatRoomModel chatRoom) async {
    try {
      // Check if a chat room with these participants already exists
      final querySnapshot = await _firestore
          .collection('chat_rooms')
          .where('participants', isEqualTo: chatRoom.participants)
          .get();

      // If there are no existing chat rooms, create a new one
      if (querySnapshot.docs.isEmpty) {
        final chatRoomModel = ChatRoomModel(
          lastMessage: chatRoom.lastMessage,
          participants: chatRoom.participants,
          timestamp: chatRoom.timestamp,
        );

        // Convert the ChatRoomModel to a Map and add it to Firestore
        DocumentReference docRef = await _firestore
            .collection('chat_rooms')
            .add(chatRoomModel.toMap());

        // Retrieve the generated chatId and update the model if necessary
        String chatId = docRef.id;
        _logger.i('Chat room $chatId created successfully.');
      } else {
        _logger.i('Chat room already exists.');
      }
    } catch (e) {
      _logger.e('Error creating chat room: $e', error: e);
    }
  }

  Future<void> updateChatRoomLastMessageAndTimeStamp({
    required String chatId,
    required String messageContent,
    required Timestamp lastMessageTimestamp,
  }) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatId).update({
        'lastMessage': messageContent,
        'lastMessageTimestamp': lastMessageTimestamp,
      });
      _logger.i('Chat room $chatId updated successfully.');
    } catch (e) {
      _logger.e('Error updating chat room $chatId: $e', error: e);
    }
  }

  Future<void> sendMessage(
    Message message,
  ) async {
    try {
      // Query for an existing chat room with the two users
      final chatRoomQuery = await _firestore.collection('chat_rooms').where(
          'participants',
          arrayContainsAny: [message.senderId, message.receiverId]).get();

      String chatId;

      if (chatRoomQuery.docs.isEmpty) {
        // If no chat room exists, create a new chat room with an auto-generated chatId
        DocumentReference chatRoomRef =
            await _firestore.collection('chat_rooms').add({
          'participants': [message.senderId, message.receiverId],
          'lastMessage': message.messageContent,
          'lastMessageTimestamp': message.timestamp,
        });

        chatId = chatRoomRef.id; // Use the auto-generated chatId
      } else {
        // If the chat room exists, use its ID
        chatId = chatRoomQuery.docs.first.id;
      }

      // Create message data
      final messageData = {
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'messageContent': message.messageContent,
        'messageType': message.messageType,
        'timestamp': message.timestamp,
      };

      // Add the message to the sub-collection
      await _firestore
          .collection('chat_rooms')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Update last message and timestamp in the chat room
      updateChatRoomLastMessageAndTimeStamp(
          chatId: chatId,
          messageContent: message.messageContent,
          lastMessageTimestamp: message.timestamp);

      _logger.i('Message sent in chat room $chatId.');
    } catch (e) {
      _logger.e('Error sending message in chat room: $e', error: e);
    }
  }

  Future<List<Message>> getMessages(
      String chatParticipantOneId, String chatParticipantTwoId) async {
    try {
      // Query the chat room by matching the participants
      final chatRoom = (await _firestore
              .collection('chat_rooms')
              .where('participants', arrayContains: chatParticipantOneId)
              .get())
          .docs
          .firstWhere(
            (doc) =>
                List<String>.from(doc['participants'])
                    .contains(chatParticipantTwoId) &&
                List<String>.from(doc['participants']).length == 2,
            orElse: () => throw Exception('Chat room not found'),
          );

      final chatRoomId = chatRoom.id;
      final messagesSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      // Convert documents to a list of maps
      final messages = messagesSnapshot.docs.map((doc) {
        final data = doc.data();
        return Message(
          messageId: doc.id,
          senderId: data['senderId'] as String,
          receiverId: data['receiverId'] as String,
          messageContent: data['messageContent'] as String,
          messageType: data['messageType'] as String,
          timestamp: data['timestamp'] as Timestamp,
        );
      }).toList();
      _logger
          .i('Fetched ${messages.length} messages from chat room $chatRoomId.');
      return messages;
    } catch (e) {
      _logger.e('Error fetching messages: $e', error: e);
      return [];
    }
  }
}
