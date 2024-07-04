import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../enums/authentication_status_enum.dart';
import '../../../models/user.dart';
import '../../../repos/authentication/authentication_repository.dart';
import '../../../repos/user/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Bloc to handle authentication state changes and manage user authentication.
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  /// Constructor initializing the bloc with repositories and states.
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);

    // Make sure the stream emits AuthenticationStatus and remove the casting if not needed
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
          (status) => add(_AuthenticationStatusChanged(status)),
    );
  }
  /// Handles changes in authentication status and updates the state accordingly.
  Future<void> _onAuthenticationStatusChanged(
      _AuthenticationStatusChanged event,
      Emitter<AuthenticationState> emit,
      ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        emit(const AuthenticationState.unauthenticated());
        break;
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
        break;
      default:
        emit(const AuthenticationState.unknown());
        break;
    }
  }

  /// Logs out the current user and updates the state to unauthenticated.
  void _onAuthenticationLogoutRequested(
      AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit,
      ) {
    _authenticationRepository.logOut();
  }

  /// Attempts to fetch the currently authenticated user's details.
  Future<User?> _tryGetUser() async {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser != null) {
      try {
        final user = await _userRepository.getUser(currentUser.uid);
        return user;
      } catch (_) {
        return null;  // Return null if fetching user fails.
      }
    }
    return null;  // Return null if no current user.
  }

  /// Overridden close method to cancel the stream subscription on bloc close.
  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }
}
