import 'package:equatable/equatable.dart';

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
  final List<User> myData;
  UsersLoadedState(this.myData);
  @override
  List<Object> get props => [myData];
}

class ErrorState extends ChatStates{
  final String error;
  ErrorState(this.error);
  @override
  List<Object> get props=> [error];
}