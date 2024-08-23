part of 'personal_chat_bloc.dart';

abstract class PersonalChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonalChatRoomCreatedState extends PersonalChatState{

}

class PersonalChatMessagesLoadedState extends PersonalChatState {
  final List<Message> messagesList;
  final String currentUserId; // Ensure this is non-nullable
  final String chatParticipantTwoId; // Ensure this is non-nullable

  PersonalChatMessagesLoadedState({
    List<Message>? messagesList,
    required this.currentUserId,
    required this.chatParticipantTwoId,
  }) : messagesList = messagesList ?? []; // Default to an empty list if null

  @override
  List<Object> get props => [
    messagesList, // List<Message> is non-nullable due to default value
    currentUserId, // Ensure it's non-nullable
    chatParticipantTwoId, // Ensure it's non-nullable
  ];
}

class PersonalChatErrorState extends PersonalChatState {
  final String error;

  PersonalChatErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class PersonalChatLoadingState extends PersonalChatState {
  @override
  List<Object> get props=> [];
}
