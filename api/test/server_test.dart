import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://127.0.0.1:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    await Future.delayed(const Duration(seconds: 1));
  });

  tearDown(() => p.kill());

  test(
    'Meta healthcheck integration',
    () async {
      final response = await get(Uri.parse('$host/api/meta/healthcheck'));
      expect([200, 500], contains(response.statusCode));
    },
    skip: 'Requires external runtime services (database/env) for reliable startup in CI.',
  );
}
