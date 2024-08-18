import 'package:bloc/bloc.dart';
import 'package:flutter_gp5/repos/user/user_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc/chat_states.dart';

import '../../../repos/authentication/authentication_repository.dart';import 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final UserRepository userRepository;
  final AuthenticationRepository authRepo;

  ChatBloc({required this.userRepository, required this.authRepo})
      : super(UsersLoadingState()) {
    on<GetAllUsers>(_onGetAllUsers);
  }

  Future<void> _onGetAllUsers(
      GetAllUsers event, Emitter<ChatStates> emit) async {
    emit(UsersLoadingState());

    try {
      final data = await userRepository.getAll();

      final email = authRepo.currentUser?.email;

      if (data.isEmpty) {
        emit(ErrorState("Collection is Empty"));
        return;
      }
      // Filter out the current user from the list
      final filteredUsers = data.where((user) => user.email != email).toList();

      // Emit the loaded state with filtered data
      emit(UsersLoadedState(filteredUsers));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
