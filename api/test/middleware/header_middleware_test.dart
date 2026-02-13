import 'package:casa_api/src/middleware/header.middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('defaultHeaders', () {
    test('adds content-type when missing', () async {
      final handler = defaultHeaders()((_) async => Response.ok('ok'));
      final response = await handler(Request('GET', Uri.parse('http://localhost/')));

      expect(response.headers['Content-Type'], 'application/json');
    });

    test('keeps content-type when already set', () async {
      final handler = defaultHeaders()(
        (_) async => Response.ok('ok', headers: {'Content-Type': 'text/plain'}),
      );
      final response = await handler(Request('GET', Uri.parse('http://localhost/')));

      expect(response.headers['Content-Type'], 'text/plain');
    });
  });
}
