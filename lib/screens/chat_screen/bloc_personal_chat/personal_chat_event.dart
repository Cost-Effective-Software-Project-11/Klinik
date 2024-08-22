part of 'personal_chat_bloc.dart';

@immutable
abstract class PersonalChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends PersonalChatEvent {
  final Message message;
  final List<Message>? messages;
  final String chatId;
  final String currentUserId;
  final String chatParticipantTwoId;
  // Constructor
  SendMessageEvent({
    required this.chatId,
    required this.currentUserId,
    required this.chatParticipantTwoId,
    required this.message,
    this.messages
  });

  @override
  List<Object> get props => [message];
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