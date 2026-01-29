import 'package:casa/src/core/auth/auth.notifier.dart';
import 'package:casa/src/core/auth/auth.state.dart';
import 'package:casa/src/core/models/enums/e_auth_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());

final authStatusProvider = Provider<EAuthStatus>((ref) {
  final authAsync = ref.watch(authProvider);

  if (authAsync.isLoading) {
    return EAuthStatus.authenticating;
  }

  final auth = authAsync.value;
  if (auth?.isAuthenticated == true) {
    return EAuthStatus.authenticated;
  }

  return EAuthStatus.unauthenticated;
});
