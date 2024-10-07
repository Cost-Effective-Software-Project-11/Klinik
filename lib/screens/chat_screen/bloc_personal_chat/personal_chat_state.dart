part of 'personal_chat_bloc.dart';

class PersonalChatState extends Equatable {
  const PersonalChatState({
    this.currentUserId = '',
    this.chatParticipantTwoId = '',
    this.textMessageInput = '',
    this.filePath = '',
    this.messagesList = const [],
    this.isLoadingMessages = false,
    this.isSendingFile = false,
    this.chatRoomId = '',
  });

  final List<Message> messagesList;
  final String currentUserId;
  final String filePath;
  final String chatParticipantTwoId;
  final String textMessageInput;
  final bool isLoadingMessages;
  final bool isSendingFile;
  final String chatRoomId;

  PersonalChatState copyWith({
    List<Message>? messagesList,
    String? currentUserId,
    String? filePath,
    String? chatParticipantTwoId,
    String? textMessageInput,
    bool? isLoadingMessages,
    bool? isSendingFile,
    String? chatRoomId,
  }) {
    return PersonalChatState(
      messagesList: messagesList ?? this.messagesList,
      currentUserId: currentUserId ?? this.currentUserId,
      chatParticipantTwoId: chatParticipantTwoId ?? this.chatParticipantTwoId,
      textMessageInput: textMessageInput ?? this.textMessageInput,
      filePath: filePath ?? this.filePath,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSendingFile: isSendingFile ?? this.isSendingFile,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  @override
  List<Object> get props => [
    messagesList,
    currentUserId,
    chatParticipantTwoId,
    textMessageInput,
    isLoadingMessages,
    isSendingFile,
    chatRoomId,
    filePath,
  ];
}

class PersonalChatLoadingState extends PersonalChatState {
  const PersonalChatLoadingState();

  @override
  List<Object> get props => [];
}

class PersonalChatErrorState extends PersonalChatState {
  const PersonalChatErrorState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
