import 'package:casa/src/core/auth/auth.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(isAuthenticated: true, isLoading: false);
    //return AuthState.initial();
  }

  Future<void> checkAuth() async {
    // z. B. Token aus SecureStorage prüfen
    state = state.copyWith(
      isAuthenticated: false,
      isLoading: false,
    );
  }

  void login() {
    state = state.copyWith(isAuthenticated: true);
  }

  void logout() {
    state = const AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }
}
