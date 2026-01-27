import 'package:casa/src/core/api/interceptors/auth_interceptor.dart';
import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:casa/src/core/services/service_locator.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  const ApiClient({required this.dio});

  factory ApiClient.initial(Uri baseUrl) {
    final client = Dio(
      BaseOptions(
        baseUrl: baseUrl.toString(),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final tokenProvider = services.get<ITokenProvider>();

    client.interceptors.add(AuthTokenInterceptor(tokenProvider));
    client.interceptors.add(LogInterceptor(responseBody: true));

    return ApiClient(dio: client);
  }
}
