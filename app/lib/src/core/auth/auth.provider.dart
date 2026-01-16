import 'package:casa/src/core/auth/auth.notifier.dart';
import 'package:casa/src/core/auth/auth.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
