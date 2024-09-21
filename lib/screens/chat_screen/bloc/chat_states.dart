import 'package:equatable/equatable.dart';

import '../../../models/message_model.dart';
import '../../../models/user.dart';

abstract class ChatStates extends Equatable{
  @override
  List<Object> get props=> [];
}
class UsersLoadingState extends ChatStates{
  @override
  List<Object> get props=> [];
}

class UsersLoadedState extends ChatStates{
  final List<User> users;
  final Map<String, Message?> lastMessages;
  final Map<String,int> unreadCount;

  UsersLoadedState(this.users, this.lastMessages,this.unreadCount);

  @override
  List<Object> get props => [users, lastMessages,unreadCount];
}

class ErrorState extends ChatStates{
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props=> [error];
}