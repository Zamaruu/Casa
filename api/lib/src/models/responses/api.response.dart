import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart' as shelf;

class ApiResponse extends shelf.Response {
  ApiResponse(super.statusCode, {super.body, super.headers, super.context});

  ApiResponse.ok(String body) : super(EHttpStatus.ok.code, body: body);

  ApiResponse.noContent(String body) : super(EHttpStatus.noContent.code, body: body);

  ApiResponse.created(String body) : super(EHttpStatus.created.code, body: body);

  ApiResponse.notFound(String body) : super(EHttpStatus.notFound.code, body: body);

  ApiResponse.internalServerError(String body) : super(EHttpStatus.internalServerError.code, body: body);

  ApiResponse.badRequest(String body) : super(EHttpStatus.badRequest.code, body: body);

  ApiResponse.unauthorized(String body) : super(EHttpStatus.unauthorized.code, body: body);

  ApiResponse.forbidden(String body) : super(EHttpStatus.forbidden.code, body: body);

  ApiResponse.methodNotAllowed(String body) : super(EHttpStatus.methodNotAllowed.code, body: body);

  ApiResponse.notAcceptable(String body) : super(EHttpStatus.notAcceptable.code, body: body);
}
