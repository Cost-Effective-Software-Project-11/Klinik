import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  file,
  textAndFile,
}
class Message extends Equatable {
  final String? messageId;
  final String? senderId;
  final String receiverId;
  final MessageType messageType;
  final String? fileName;
  final String messageContent;
  final Timestamp timestamp;
  final bool isRead;

  // Constructor
  const Message({
    this.messageId,
    this.senderId,
    this.fileName,
    required this.receiverId,
    required this.messageType,
    required this.messageContent,
    required this.timestamp,
    required this.isRead,
  });

  // Convert a Firestore document to a Message instance
  factory Message.fromMap(Map<String, dynamic> map, String messageId) {
    return Message(
      messageId: messageId,
      senderId: map['senderId'] as String?,
      fileName: map['fileName'] as String?,
      receiverId: map['receiverId'] as String,
      messageType: _messageTypeFromString(map['messageType'] as String),
      messageContent: map['messageContent'] as String,
      timestamp: map['timestamp'] as Timestamp,
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  // Convert a Message instance to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'fileName': fileName,
      'messageType': _messageTypeToString(messageType),
      'messageContent': messageContent,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  // Convert MessageType enum to string for Firestore
  static String _messageTypeToString(MessageType messageType) {
    switch (messageType) {
      case MessageType.text:
        return 'text';
      case MessageType.file:
        return 'file';
      case MessageType.textAndFile:
        return 'textAndFile';
      default:
        return 'text';
    }
  }

  // Convert string from Firestore to MessageType enum
  static MessageType _messageTypeFromString(String messageType) {
    switch (messageType) {
      case 'text':
        return MessageType.text;
      case 'file':
        return MessageType.file;
      case 'textAndFile':
        return MessageType.textAndFile;
      default:
        return MessageType.text;
    }
  }

  @override
  List<Object?> get props => [senderId, receiverId, messageContent, timestamp, isRead, messageType,fileName];
}
