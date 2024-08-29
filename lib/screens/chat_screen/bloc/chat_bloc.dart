import 'package:bloc/bloc.dart';
import 'package:flutter_gp5/repos/user/user_repository.dart';
import 'package:flutter_gp5/screens/chat_screen/bloc/chat_states.dart';

import 'chat_events.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  final UserRepository userRepository;

  ChatBloc({required this.userRepository}) :super(UsersLoadingState()) {
    on<GetAllUsers>(_onGetAllUsers);
  }


  Future<void> _onGetAllUsers(GetAllUsers event, Emitter<ChatStates> emit) async {
    emit(UsersLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    try {
      final data = await userRepository.getAll();
      if(data.isEmpty)
        {
          emit(ErrorState("Collection is Empty"));
        }
      emit(UsersLoadedState(data));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}