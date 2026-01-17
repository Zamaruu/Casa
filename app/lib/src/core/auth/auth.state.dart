import 'package:shared/shared.dart';

class AuthState implements ICopyable {
  final bool isAuthenticated;
  final bool isLoading;
  final IUser user;

  const AuthState({
    required this.user,
    required this.isAuthenticated,
    required this.isLoading,
  });

  factory AuthState.initial() {
    return AuthState(
      user: AuthUser.initial(),
      isAuthenticated: false,
      isLoading: true,
    );
  }

  @override
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    IUser? user,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
