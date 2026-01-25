import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart' as shelf;

class ApiResponse extends shelf.Response {
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
  };

  ApiResponse(super.statusCode, {super.body, super.headers, super.context});

  ApiResponse.ok(String body) : super(EHttpStatus.ok.code, body: body, headers: defaultHeaders);

  ApiResponse.noContent(String body) : super(EHttpStatus.noContent.code, body: body, headers: defaultHeaders);

  ApiResponse.created(String body) : super(EHttpStatus.created.code, body: body, headers: defaultHeaders);

  ApiResponse.notFound(String body) : super(EHttpStatus.notFound.code, body: body, headers: defaultHeaders);

  ApiResponse.internalServerError(String body) : super(EHttpStatus.internalServerError.code, body: body, headers: defaultHeaders);

  ApiResponse.badRequest(String body) : super(EHttpStatus.badRequest.code, body: body, headers: defaultHeaders);

  ApiResponse.unauthorized(String body) : super(EHttpStatus.unauthorized.code, body: body, headers: defaultHeaders);

  ApiResponse.forbidden(String body) : super(EHttpStatus.forbidden.code, body: body, headers: defaultHeaders);

  ApiResponse.methodNotAllowed(String body) : super(EHttpStatus.methodNotAllowed.code, body: body, headers: defaultHeaders);

  ApiResponse.notAcceptable(String body) : super(EHttpStatus.notAcceptable.code, body: body, headers: defaultHeaders);
}
