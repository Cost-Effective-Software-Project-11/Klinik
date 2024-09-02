import 'dart:async';
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
  StreamSubscription<List<Message>>? _messagesSubscription;
  final ChatRepository chatRoomRepository;
  final AuthenticationRepository authRepository;

  PersonalChatBloc({
    required this.chatRoomRepository,
    required this.authRepository,
  }) : super(const PersonalChatState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<GetMessagesEvent>(_onGetMessages);
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<UpdateTextMessageEvent>(_onUpdateTextMessage);
    on<MessagesUpdated>(_onMessagesUpdated); // Register the MessagesUpdated event
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<PersonalChatState> emit) async {
    try {
      // Get the current user ID
      final currentUserId = authRepository.currentUser?.uid;
      if (currentUserId == null) {
        emit(PersonalChatErrorState('User is not logged in'));
        return;
      }

      // Create the new Message object using the event data
      final newMessage = Message(
        senderId: currentUserId,
        receiverId: event.receiverId,
        messageContent: event.messageContent,
        timestamp: event.timestamp,
      );

      // Send the message using the repository
      await chatRoomRepository.sendMessage(newMessage);

      // No need to manually update the state with the new message,
      // as it will be automatically handled by the stream in the _onMessagesUpdated method.
    } catch (e) {
      emit(PersonalChatErrorState('Error sending message: $e'));
    }
  }

  Future<void> _onGetMessages(
      GetMessagesEvent event, Emitter<PersonalChatState> emit) async {
    try {
      final currentUserId = authRepository.currentUser?.uid;
      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }
      _messagesSubscription?.cancel();

      // Subscribe to the stream of messages
      _messagesSubscription = chatRoomRepository
          .getMessagesStream(currentUserId, event.chatParticipantTwoId)
          .listen((messages) {
        add(MessagesUpdated(messages: messages));
      });
      emit(const PersonalChatState());
    } catch (e) {
      emit(PersonalChatErrorState('Error fetching messages: $e'));
    }
  }

  void _onMessagesUpdated(
      MessagesUpdated event, Emitter<PersonalChatState> emit) {
    emit(state.copyWith(messagesList: event.messages));
  }

  Future<void> _onCreateChatRoom(
      CreateChatRoomEvent event, Emitter<PersonalChatState> emit) async {
    try {
      final currentUserId = authRepository.currentUser?.uid;
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

      emit(const PersonalChatLoadingState());
    } catch (e) {
      emit(PersonalChatErrorState('Error creating chat room: $e'));
    }
  }

  void _onUpdateTextMessage(UpdateTextMessageEvent event, Emitter<PersonalChatState> emit) {
    final textMessageInput = event.textMessageInput;
    emit(state.copyWith(textMessageInput: textMessageInput));
  }

  @override
  Future<void> close() {
    // Cancel the subscription when the Bloc is closed
    _messagesSubscription?.cancel();
    return super.close();
  }
}
