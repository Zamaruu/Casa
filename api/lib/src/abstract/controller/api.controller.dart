import 'dart:convert';

import 'package:api/src/models/responses/http.response.dart';
import 'package:api/src/utils/logger.util.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ApiController {
  final Router router;

  ApiController() : router = Router();

  String get path;

  Handler get handler => router.call;

  Future<void> registerEndpoints();

  Future<HttpResponse> runGuarded(Future<HttpResponse> Function() endpointHandler) async {
    try {
      return await endpointHandler();
    } catch (e, st) {
      final message = "Unexpected exeption in ${runtimeType.toString()}";
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);

      final errorMap = <String, String>{
        "message": message,
        "error": e.toString(),
        "stackTrace": st.toString(),
      };

      final json = jsonEncode(errorMap);

      return HttpResponse.internalServerError(json);
    }
  }
}
