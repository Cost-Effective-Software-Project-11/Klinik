import 'dart:async';

enum _AuthenticationStatus { unknown, authenticated, unauthenticated }

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
      const Duration(milliseconds: 300),
      () => _controller.add(_AuthenticationStatus.authenticated),
    );
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
