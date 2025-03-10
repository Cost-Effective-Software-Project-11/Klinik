import 'package:flutter_gp5/enums/user_type.dart';
import 'package:flutter_gp5/models/workplace.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'uid') required String id,
    required String email,
    required String name,
    required String phone,
    required Workplace workplace,
    required UserType userType,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
