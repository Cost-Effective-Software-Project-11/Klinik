part of 'personal_chat_bloc.dart';

class PersonalChatState extends Equatable {
  const PersonalChatState({
    this.currentUserId = '',
    this.chatParticipantTwoId = '',
    this.textMessageInput = '',
    this.messagesList = const [],
    this.isLoadingMessages=false
  });

  final List<Message> messagesList;
  final String currentUserId;
  final String chatParticipantTwoId;
  final String textMessageInput;
  final bool isLoadingMessages;

  PersonalChatState copyWith({
    List<Message>? messagesList,
    String? currentUserId,
    String? chatParticipantTwoId,
    String? textMessageInput,
    bool? isLoadingMessages,
  }) {
    return PersonalChatState(
      messagesList: messagesList ?? this.messagesList,
      currentUserId: currentUserId ?? this.currentUserId,
      chatParticipantTwoId: chatParticipantTwoId ?? this.chatParticipantTwoId,
      textMessageInput: textMessageInput ?? this.textMessageInput,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
    );
  }

  @override
  List<Object> get props => [messagesList, currentUserId, chatParticipantTwoId,textMessageInput,isLoadingMessages];
}

class PersonalChatLoadingState extends PersonalChatState {
  const PersonalChatLoadingState();

  @override
  List<Object> get props=> [];
}

class PersonalChatErrorState extends PersonalChatState {
  const PersonalChatErrorState(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}