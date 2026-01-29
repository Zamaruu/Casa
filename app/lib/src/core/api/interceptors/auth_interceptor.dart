import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  final ITokenProvider tokenProvider;

  AuthTokenInterceptor(this.tokenProvider);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = tokenProvider.accessToken;

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
