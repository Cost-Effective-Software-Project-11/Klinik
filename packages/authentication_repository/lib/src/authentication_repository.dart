import 'dart:async';

enum _AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<_AuthenticationStatus>();

  Stream<_AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield _AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () => _controller.add(_AuthenticationStatus.authenticated),
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
    _controller.add(_AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
