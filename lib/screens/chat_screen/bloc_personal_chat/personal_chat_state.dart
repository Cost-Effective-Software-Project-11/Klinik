part of 'personal_chat_bloc.dart';

class PersonalChatState extends Equatable {
  const PersonalChatState({
    this.currentUserId = '',
    this.chatPartnerId = '',
    this.textMessageInput = '',
    this.filePath = '',
    this.messagesList = const [],
    this.isLoadingMessages = false,
    this.isSendingFile = false,
    this.isDownloadingFile = false,
    this.chatRoomId = '',
  });

  final List<Message> messagesList;
  final String currentUserId;
  final String filePath;
  final String chatPartnerId;
  final String textMessageInput;
  final bool isLoadingMessages;
  final bool isSendingFile;
  final bool isDownloadingFile;
  final String chatRoomId;

  PersonalChatState copyWith({
    List<Message>? messagesList,
    String? currentUserId,
    String? filePath,
    String? chatParticipantTwoId,
    String? textMessageInput,
    bool? isLoadingMessages,
    bool? isSendingFile,
    bool? isDownloadingFile,
    String? chatRoomId,
  }) {
    return PersonalChatState(
      messagesList: messagesList ?? this.messagesList,
      currentUserId: currentUserId ?? this.currentUserId,
      chatPartnerId: chatParticipantTwoId ?? this.chatPartnerId,
      textMessageInput: textMessageInput ?? this.textMessageInput,
      filePath: filePath ?? this.filePath,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSendingFile: isSendingFile ?? this.isSendingFile,
      isDownloadingFile: isDownloadingFile ?? this.isDownloadingFile,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  @override
  List<Object> get props => [
    messagesList,
    currentUserId,
    chatPartnerId,
    textMessageInput,
    isLoadingMessages,
    isSendingFile,
    isDownloadingFile,
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
