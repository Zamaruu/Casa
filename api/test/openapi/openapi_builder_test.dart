import 'package:casa_api/src/openapi/openapi_builder.dart';
import 'package:test/test.dart';

void main() {
  test('OpenapiBuilder builds swagger html with expected anchors', () {
    final html = OpenapiBuilder.buildSwaggerHtml();

    expect(html, contains('<!DOCTYPE html>'));
    expect(html, contains('SwaggerUIBundle'));
    expect(html, contains('/api/swagger/specs'));
  });
}
