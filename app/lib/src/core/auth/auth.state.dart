import 'package:shared/shared.dart';

class AuthState implements ICopyable {
  final IUser? user;

  final String token;

  // region Constructors

  const AuthState({
    required this.token,
    this.user,
  });

  factory AuthState.initial() {
    return AuthState(
      token: '',
    );
  }

  // endregion

  bool get isAuthenticated => user != null;

  @override
  AuthState copyWith({
    IUser? user,
    String? token,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}
