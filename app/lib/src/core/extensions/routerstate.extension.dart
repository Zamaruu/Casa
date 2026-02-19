import 'package:go_router/go_router.dart';

extension RouterState on GoRouterState {
  Map<String, String> get queryParameters {
    final params = uri.queryParameters;
    return params;
  }
}
