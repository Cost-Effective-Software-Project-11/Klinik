import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Define the Message model class
class Message extends Equatable {
  final String? messageId;
  final String? senderId;
  final String receiverId;
  final String messageContent;
  final Timestamp timestamp;
  final bool isRead;

  // Constructor
  const Message({
    this.messageId,
    this.senderId,
    required this.receiverId,
    required this.messageContent,
    required this.timestamp,
    required this.isRead
  });

  // Convert a Firestore document to a Message instance
  factory Message.fromMap(Map<String, dynamic> map,String messageId) {
    return Message(
      messageId: messageId,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      messageContent: map['messageContent'] as String,
      timestamp: map['timestamp'] as Timestamp,
      isRead: map['isRead'] as bool? ?? false, // Handle null values
    );
  }

  // Convert a Message instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageContent': messageContent,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  @override
  List<Object?> get props => [senderId, receiverId, messageContent,timestamp,isRead];
}