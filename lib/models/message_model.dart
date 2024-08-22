import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Define the Message model class
class Message extends Equatable {
  final String? messageId;
  final String senderId;
  final String receiverId;
  final String messageContent;
  final String messageType;
  final Timestamp timestamp;

  // Constructor
  const Message({
    this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageContent,
    required this.messageType,
    required this.timestamp,
  });

  // Convert a Firestore document to a Message instance
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      messageContent: map['messageContent'] as String,
      messageType: map['messageType'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  // Convert a Message instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageContent': messageContent,
      'messageType': messageType,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [senderId, receiverId, messageContent, messageType, timestamp];
}