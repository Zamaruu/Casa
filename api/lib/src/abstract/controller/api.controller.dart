import 'dart:convert';

import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/auth/user_context.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class ApiController extends GuardedOperations {
  final Router router;

  final ILogger logger;

  ApiController({required this.logger}) : router = Router();

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

  ApiResponse onGuardedError(String message, Object error, StackTrace stackTrace) {
    final errorResult = encodeError(message: message, error: error, stackTrace: stackTrace);
    final json = jsonEncode(errorResult);

    return ApiResponse.internalServerError(json);
  }

  @override
  Future<void> guardedErrorCallback(String title, Object error, StackTrace stackTrace) async {
    final errorLog = ErrorLog(
      title: title,
      message: error.toString(),
      stackTrace: stackTrace,
      logLevel: ELogLevel.error,
      exceptionType: error.runtimeType.toString(),
    );

    await logger.log(errorLog);
  }

  UserContext userContext(Request request) {
    final ctx = request.context["UserContext"];
    if (ctx == null) {
      throw StateError('UserContext missing');
    }
    return ctx as UserContext;
  }
}
