import 'package:shelf/shelf.dart';

Middleware defaultHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      if (response.headers.containsKey('Content-Type')) {
        return response;
      }
      return response.change(headers: {'Content-Type': 'application/json'});
    };
  };
}
