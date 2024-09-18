import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Define the Message model class
class Message extends Equatable {
  final String? messageId;
  final String? senderId;
  final String receiverId;
  final String messageContent;
  final Timestamp timestamp;

  // Constructor
  const Message({
    this.messageId,
    this.senderId,
    required this.receiverId,
    required this.messageContent,
    required this.timestamp,
  });

  // Convert a Firestore document to a Message instance
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      messageContent: map['messageContent'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  // Convert a Message instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'messageContent': messageContent,
      'timestamp': timestamp,
    };
  }

  @override
  List<Object?> get props => [senderId, receiverId, messageContent,timestamp];
}