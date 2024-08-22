import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  final String? chatRoomId; // Nullable chatRoomId
  final String lastMessage;
  final List<String> participants; // List of participant IDs
  final Timestamp timestamp;

  // Constructor
  const ChatRoomModel({
    this.chatRoomId,
    required this.lastMessage,
    required this.participants,
    required this.timestamp,
  });

  // Convert ChatRoomModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage,
      'participants': participants,
      'timestamp': timestamp,
    };
  }

  // Create a ChatRoomModel from Firestore Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ChatRoomModel(
      chatRoomId: id ?? map['chatRoomId'] as String?,
      lastMessage: map['lastMessage'] ?? '',
      participants: List<String>.from(map['participants']),
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  @override
  List<Object?> get props => [chatRoomId, lastMessage, participants, timestamp];
}