import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/models/message_model.dart';

class ChatRoomModel extends Equatable {
  final String lastMessage;
  final List<String> participants; // List of participant IDs
  final Timestamp timestamp;
  final List<Message>? messages;

  // Constructor
  const ChatRoomModel({
    required this.lastMessage,
    required this.participants,
    required this.timestamp,
    this.messages
  });

  // Convert ChatRoomModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'participants': participants,
      'timestamp': timestamp,
    };
  }

  // Create a ChatRoomModel from Firestore Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ChatRoomModel(
      lastMessage: map['lastMessage'] ?? '',
      participants: List<String>.from(map['participants']),
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  @override
  List<Object?> get props => [lastMessage, participants, timestamp];
}