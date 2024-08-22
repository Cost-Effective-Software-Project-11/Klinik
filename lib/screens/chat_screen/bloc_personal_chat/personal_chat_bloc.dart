import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../models/chat_room_model.dart';
import '../../../models/message_model.dart';
import '../../../repos/authentication/authentication_repository.dart';
import '../../../repos/chat/chat_room_repository.dart';

part 'personal_chat_event.dart';

part 'personal_chat_state.dart';

class PersonalChatBloc extends Bloc<PersonalChatEvent, PersonalChatState> {
  final ChatRoomRepository chatRoomRepository;
  final AuthenticationRepository authRepository;

  PersonalChatBloc(
      {required this.chatRoomRepository, required this.authRepository})
      : super(PersonalChatStateInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<GetMessagesEvent>(_getMessages);
    on<CreateChatRoomEvent>(_createChatRoom);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<PersonalChatState> emit) async {
    try {
      // Emit a loading state before sending the message
      emit(PersonalChatMessagesLoadedState(
          messagesList: event.messages,
          currentUserId: event.currentUserId,
          chatParticipantTwoId: event.chatParticipantTwoId));

      // Send the message using the repository
      await chatRoomRepository.sendMessage(event.message);

      // Retrieve the updated messages list from the repository
      final messagesList = await chatRoomRepository.getMessages(
        event.message.receiverId,
        event.message.senderId,
      );
      // Emit the state with the updated messages
      emit(PersonalChatMessageSentState(
        messagesList: messagesList,
      ));
    } catch (e) {
      // Emit an error state if something goes wrong
      emit(PersonalChatErrorState('Error sending message: $e'));
    }
  }

  Future<void> _getMessages(
      GetMessagesEvent event, Emitter<PersonalChatState> emit) async {
    try {
      var currentUserId = authRepository.currentUser?.uid;
      if (currentUserId == null) {
        emit(PersonalChatErrorState('User is not logged in'));
        return;
      }
      emit(PersonalChatLoadingState());
      final messagesList = (await chatRoomRepository.getMessages(
          currentUserId , event.chatParticipantTwoId));

      // Emit the state with the fetched messages
      emit(PersonalChatMessagesLoadedState(
          messagesList: messagesList,
          currentUserId: currentUserId,
          chatParticipantTwoId: event.chatParticipantTwoId));
    } catch (e) {
      emit(PersonalChatErrorState('Error fetching messages: $e'));
    }
  }

  Future<void> _createChatRoom(
    CreateChatRoomEvent event,
    Emitter<PersonalChatState> emit,
  ) async {
    try {
      var currentUserId = authRepository.currentUser?.uid;
      print(currentUserId);

      if (currentUserId == null) {
        emit(PersonalChatErrorState('User is not logged in'));
        return;
      }

      final chatParticipantId = event.chatParticipantTwoId;
      final chatRoom = ChatRoomModel(
        participants: [currentUserId, chatParticipantId],
        lastMessage: '',
        timestamp: Timestamp.now(),
      );

      // Call repository to create the chat room with the model
      await chatRoomRepository.createChatRoom(chatRoom);

    } catch (e) {
      emit(PersonalChatErrorState('Error creating chat room: $e'));
    }
  }
}
