import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;

  const User({
    required this.id,
    required this.email,
    required this.username,
  });

  @override
  List<Object?> get props => [id, email, username];

  // Using named constructor to handle nulls and provide default values if necessary
  factory User.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError('Data must not be null');
    }
    final String id = data['id'] as String? ?? '-';
    final String email = data['email'] as String? ?? '';
    final String username = data['username'] as String? ?? '';

    if (id.isEmpty || email.isEmpty || username.isEmpty) {
      throw StateError('Required fields are missing');
    }

    return User(
      id: id,
      email: email,
      username: username,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }

  static const empty = User(id: '-', email: '', username: '');
}
