import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gp5/services/storage_service.dart';

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
    on<MessagesUpdated>(_onMessagesUpdated);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
    on<GetFilePath>(_onGetFilePath);
    on<DownloadFile>(_onDownloadFile);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<PersonalChatState> emit) async {
    try {
      final currentUserId = authRepository.currentUser?.uid;
      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }
      if(event.fileName!='')
      {
        emit(state.copyWith(isSendingFile: true));
      }
      final newMessage = Message(
        senderId: currentUserId,
        messageType: event.messageType,
        fileName: event.fileName,
        receiverId: event.receiverId,
        messageContent: event.messageContent ?? '',
        timestamp: event.timestamp,
        isRead: false,
      );
      await chatRoomRepository.sendMessage(newMessage);
      emit(state.copyWith(filePath: '', isSendingFile: false));
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

      _messagesSubscription = chatRoomRepository
          .getMessagesStream(currentUserId, event.chatParticipantTwoId)
          .listen((messages) {
        if (isClosed) return;

        add(MessagesUpdated(messages: messages));
      });
    } catch (e) {
      emit(PersonalChatErrorState('Error fetching messages: $e'));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
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
      final chatRoomId = await chatRoomRepository.createChatRoom(chatRoom);
      if (chatRoomId != null) {
        emit(PersonalChatState(chatRoomId: chatRoomId));
      } else {
        emit(const PersonalChatState());
      }
    } catch (e) {
      emit(PersonalChatErrorState('Error creating chat room: $e'));
    }
  }

  void _onUpdateTextMessage(
      UpdateTextMessageEvent event, Emitter<PersonalChatState> emit) {
    final textMessageInput = event.textMessageInput;
    emit(state.copyWith(textMessageInput: textMessageInput));
  }

  Future<void> _onLoadMoreMessages(
      LoadMoreMessagesEvent event, Emitter<PersonalChatState> emit) async {
    if (state.isLoadingMessages == true || state.messagesList.isEmpty) return;

    emit(
      state.copyWith(isLoadingMessages: true),
    );

    try {
      final lastMessage = state.messagesList.last;
      final moreMessages = await chatRoomRepository.getMoreMessages(
        currentUserId: authRepository.currentUser!.uid,
        chatParticipantTwoId: event.chatParticipantTwoId,
        lastMessage: lastMessage,
        limit: 15,
      );

      final allMessages = List<Message>.from(state.messagesList)
        ..addAll(moreMessages);

      emit(state.copyWith(
        messagesList: allMessages,
        isLoadingMessages: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMessages: false));
      emit(PersonalChatErrorState('Error loading more messages: $e'));
    }
  }

  Future<void> _onGetFilePath(GetFilePath event, Emitter<PersonalChatState> emit) async {
    try {
      final currentUserId = authRepository.currentUser?.uid;
      final storageService = StorageService();

      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }

      final String? filePath = await storageService.pickFilePath();
      if (filePath != null) {
        emit(state.copyWith(filePath: filePath));
        print(state.filePath);
      } else {
        emit(const PersonalChatErrorState('No file selected'));
      }
    } catch (e) {
      emit(PersonalChatErrorState('Error uploading file: $e'));
    }
  }

  Future<void> _onDownloadFile(DownloadFile event, Emitter<PersonalChatState> emit) async {
    try {
      final currentUserId = authRepository.currentUser?.uid;
      final storageService = StorageService();

      // Check if the user is logged in
      if (currentUserId == null) {
        emit(const PersonalChatErrorState('User is not logged in'));
        return;
      }

      // Ensure event.fileName is not null or empty
      if (event.fileName.isEmpty) {
        emit(const PersonalChatErrorState('File name cannot be empty'));
        return;
      }
      await storageService.downloadFile(event.fileName, event.chatRoomId);
    } catch (e) {
      emit(PersonalChatErrorState('Error downloading file: $e'));
    }
  }

}
