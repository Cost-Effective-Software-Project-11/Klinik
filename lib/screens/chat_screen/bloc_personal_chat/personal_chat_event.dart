part of 'personal_chat_bloc.dart';

@immutable
abstract class PersonalChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends PersonalChatEvent {
  final String receiverId;
  final String messageContent;
  final Timestamp timestamp;
  final String messageType;

  // Constructor
  SendMessageEvent({
    required this.receiverId,
    required this.messageContent,
    required this.timestamp,
    required this.messageType,
  });
}


class GetMessagesEvent extends PersonalChatEvent {
  final List<Message>? messages;
  final String chatParticipantTwoId;
  // Constructor
  GetMessagesEvent({
    required this.chatParticipantTwoId,
    this.messages,
  });

  @override
  List<Object> get props => [chatParticipantTwoId];
}

class CreateChatRoomEvent extends PersonalChatEvent {
  final String chatParticipantTwoId;

  CreateChatRoomEvent({
    required this.chatParticipantTwoId,
  });

  @override
  List<Object> get props => [chatParticipantTwoId];
}