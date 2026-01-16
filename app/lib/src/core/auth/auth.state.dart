import 'package:shared/shared.dart';

class AuthState implements ICopyable {
  final bool isAuthenticated;
  final bool isLoading;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
  });

  factory AuthState.initial() {
    return const AuthState(
      isAuthenticated: false,
      isLoading: true,
    );
  }

  @override
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
