import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required Uri baseUrl,
    required String? accessToken,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl.toString(),
           headers: {
             if (accessToken != null) 'Authorization': 'Bearer $accessToken',
           },
         ),
       );

  factory ApiClient.initial(Uri baseUrl) {
    return ApiClient(baseUrl: baseUrl, accessToken: null);
  }
}
