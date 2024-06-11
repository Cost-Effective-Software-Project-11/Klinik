import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    // API call to register the user
    // Handle response and errors
  }

  bool isLoggedIn() {
    // Check if a stored token is available and not expired
    return false;
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
