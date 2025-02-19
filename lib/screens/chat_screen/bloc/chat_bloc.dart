import 'package:bloc/bloc.dart';
import 'package:flutter_gp5/models/message_model.dart';
import 'package:flutter_gp5/models/user.dart';
import 'package:flutter_gp5/repos/user/user_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc/chat_states.dart';

import '../../../repos/authentication/authentication_repository.dart';
import '../../../repos/chat/chat_room_repository.dart';
import 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final UserRepository userRepository;
  final ChatRepository chatRoomRepository;
  final AuthenticationRepository authRepo;

  ChatBloc({required this.userRepository, required this.authRepo,required this.chatRoomRepository,})
      : super(UsersLoadingState()) {
    on<GetUsersInChatWithCurrentUser>(getUsersInChatWithCurrentUser);
  }

  Future<void> getUsersInChatWithCurrentUser(
      GetUsersInChatWithCurrentUser event, Emitter<ChatStates> emit) async {
    emit(UsersLoadingState());
    try {
      //final currentUserId = authRepo.currentUser?.uid;
      final currentUserId = '';
      if (currentUserId != null) {
        // Fetch users in chat with the current user
        final chatPartners = await userRepository.getUsersInChatWith(currentUserId);

        if (chatPartners.isEmpty) {
          emit(ErrorState("No users found in chat."));
          return;
        }
        // Initialize the lastMessages map
        final lastMessages = <String, Message?>{};
        final unreadCount = <String, int>{};

        // Fetch the last message for each user
        for (var chatPartner in chatPartners) {
          final lastMessageObject = await chatRoomRepository.getLastMessageFromChatRoom(currentUserId,chatPartner.id);
          lastMessages[chatPartner.id] = lastMessageObject;
          unreadCount[chatPartner.id]= await chatRoomRepository.getUnreadMessagesCount(currentUserId, chatPartner.id);
        }
        emit(UsersLoadedState(chatPartners,lastMessages,unreadCount));
      } else {
        emit(ErrorState("Current user not found."));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

}

