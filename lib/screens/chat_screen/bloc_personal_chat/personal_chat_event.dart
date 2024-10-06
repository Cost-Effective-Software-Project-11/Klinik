part of 'personal_chat_bloc.dart';

abstract class PersonalChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends PersonalChatEvent {
  final String receiverId;
  final String? messageContent;
  final MessageType messageType;
  final Timestamp timestamp;
  final String? filePath;
  final String? fileName;

  SendMessageEvent({
    required this.receiverId,
    this.messageContent,
    required this.messageType, // MessageType enum
    required this.timestamp,
    this.filePath,
    this.fileName,
  });

  @override
  List<Object> get props => [receiverId, messageContent ?? '', messageType, timestamp,filePath??'',fileName??''];
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

class LoadMoreMessagesEvent extends PersonalChatEvent {
  final String chatParticipantTwoId;

   LoadMoreMessagesEvent({
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

class MessagesUpdated extends PersonalChatEvent {
  final List<Message> messages;

  MessagesUpdated({required this.messages});

  @override
  List<Object> get props => [messages];
}

class GetFilePath extends PersonalChatEvent {
  GetFilePath();
}

class DownloadFile extends PersonalChatEvent {
  final String fileName;
  final String chatRoomId;
  DownloadFile({required this.fileName,required this.chatRoomId});
  @override
  List<Object> get props => [fileName,chatRoomId];
}