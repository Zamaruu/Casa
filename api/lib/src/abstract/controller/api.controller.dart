import 'dart:convert';

import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/auth/user_context.dart';
import 'package:casa_api/src/utils/logger.util.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ApiController {
  final Router router;

  ApiController() : router = Router();

  String get path;

  Router get handler => router;

  void registerEndpoints();

  String encodeError({required String message, Object? error, StackTrace? stackTrace}) {
    final result = Result(
      message: message,
      error: error?.toString(),
      stackTrace: stackTrace,
    );

    final json = result.toJson();

    return jsonEncode(json);
  }

  String encodeResult({required String message, ISerializable? value}) {
    final result = Result(
      message: message,
      value: value,
    );

    final json = result.toJson();

    return jsonEncode(json);
  }

  Future<ApiResponse> runGuarded(Future<ApiResponse> Function() endpointHandler) async {
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

      return ApiResponse.internalServerError(json);
    }
  }

  UserContext userContext(Request request) {
    final ctx = request.context["UserContext"];
    if (ctx == null) {
      throw StateError('UserContext missing');
    }
    return ctx as UserContext;
  }
}
