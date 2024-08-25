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
  final ChatRepository chatRoomRepository;
  final AuthenticationRepository authRepository;

  PersonalChatBloc(
      {required this.chatRoomRepository, required this.authRepository})
      : super(const PersonalChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<GetMessagesEvent>(_onGetMessages);
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<UpdateTextMessageEvent>(_onUpdateTextMessage);
    on<ClearMessageInputEvent>(_onClearMessageInput);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<PersonalChatState> emit) async {
    try {
      final currentState = state;
      if (currentState is PersonalChatMessagesLoadedState) {
        // Get the current user ID
        dynamic currentUserId = authRepository.currentUser?.uid;
        if (currentUserId == null) {
          emit(PersonalChatErrorState('User is not logged in'));
          return;
        }
        else {
          // Create the new Message object using the event data
          final newMessage = Message(
            senderId: currentUserId,
            receiverId: event.receiverId,
            messageContent: event.messageContent,
            messageType: event.messageType,
            timestamp: event.timestamp,
          );

          // Retrieve the current messages from the state
          final currentMessages = currentState.messagesList;

          // Add the new message to the list
          final updatedMessagesList = [...currentMessages, newMessage];

          // Emit the updated state with the new message
          emit(PersonalChatMessagesLoadedState(
            messagesList: updatedMessagesList,
            currentUserId: currentState.currentUserId,
            chatParticipantTwoId: currentState.chatParticipantTwoId,
          ));

          // Send the message using the repository
          await chatRoomRepository.sendMessage(newMessage);
        }
      } else {
        // Handle the case where the current state is not as expected
        emit(PersonalChatErrorState('Unexpected state: $currentState'));
      }
    } catch (e) {
      // Emit an error state if something goes wrong
      emit(PersonalChatErrorState('Error sending message: $e'));
    }
  }

  Future<void> _onGetMessages(
      GetMessagesEvent event, Emitter<PersonalChatState> emit) async {
    try {
      var currentUserId = authRepository.currentUser?.uid;
      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }
      final messagesList = (await chatRoomRepository.getMessages(
          currentUserId, event.chatParticipantTwoId));

      // Emit the state with the fetched messages
      emit(PersonalChatMessagesLoadedState(
          messagesList: messagesList,
          currentUserId: currentUserId,
          chatParticipantTwoId: event.chatParticipantTwoId));
    } catch (e) {
      emit(PersonalChatErrorState('Error fetching messages: $e'));
    }
  }

  Future<void> _onCreateChatRoom(CreateChatRoomEvent event, Emitter<PersonalChatState> emit) async {
    try {
      var currentUserId = authRepository.currentUser?.uid;
      print(currentUserId);

      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }
      final chatParticipantId = event.chatParticipantTwoId;

      final chatRoom = ChatRoomModel(
        participants: [currentUserId, chatParticipantId],
        lastMessage: '',
        timestamp: Timestamp.now(),
      );

      // Call repository to create the chat room with the model if such chat room doesn't exist
      await chatRoomRepository.createChatRoom(chatRoom);

      // Emit the success state and then dispatch GetMessagesEvent
      emit(PersonalChatRoomCreatedState());
    } catch (e) {
      emit(PersonalChatErrorState('Error creating chat room: $e'));
    }
  }

  void _onUpdateTextMessage(UpdateTextMessageEvent event, Emitter<PersonalChatState> emit){
    final textMessageInput = event.textMessageInput;
    emit(state.copyWith(textMessageInput: textMessageInput));
  }

  void _onClearMessageInput(ClearMessageInputEvent event, Emitter<PersonalChatState> emit){
    emit(state.copyWith(textMessageInput: ''));
  }
}
