import 'package:equatable/equatable.dart';

abstract class ChatEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllUsers extends ChatEvents {
  GetAllUsers();
}
