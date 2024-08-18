import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'personal_chat_event.dart';
part 'personal_chat_state.dart';

class PersonalChatBloc extends Bloc<PersonalChatEvent, PersonalChatState> {
  PersonalChatBloc() : super(PersonalChatInitial()) {
    on<PersonalChatEvent>((event, emit) {
    });
  }
}
