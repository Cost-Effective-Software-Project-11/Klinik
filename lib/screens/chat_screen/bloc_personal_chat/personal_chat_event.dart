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

class UpdateTextMessageEvent extends PersonalChatEvent {
  final String textMessageInput;

  UpdateTextMessageEvent(this.textMessageInput);

  @override
  List<Object> get props => [textMessageInput];
}

class ClearMessageInputEvent extends PersonalChatEvent {
  ClearMessageInputEvent();

  @override
  List<Object> get props => [];
}