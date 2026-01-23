import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class HttpResponse extends http.Response {
  HttpResponse(super.body, super.statusCode);

  HttpResponse.ok(String body) : super(body, EHttpStatus.ok.code);

  HttpResponse.noContent(String body) : super(body, EHttpStatus.noContent.code);

  HttpResponse.created(String body) : super(body, EHttpStatus.created.code);

  HttpResponse.unkownError(String body) : super(body, EHttpStatus.internalServerError.code);

  HttpResponse.notFound(String body) : super(body, EHttpStatus.notFound.code);

  HttpResponse.internalServerError(String body) : super(body, EHttpStatus.internalServerError.code);

  HttpResponse.badRequest(String body) : super(body, EHttpStatus.badRequest.code);

  HttpResponse.unauthorized(String body) : super(body, EHttpStatus.unauthorized.code);

  HttpResponse.forbidden(String body) : super(body, EHttpStatus.forbidden.code);

  HttpResponse.methodNotAllowed(String body) : super(body, EHttpStatus.methodNotAllowed.code);

  HttpResponse.notAcceptable(String body) : super(body, EHttpStatus.notAcceptable.code);
}
