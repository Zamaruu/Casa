import 'package:shared/shared.dart';
import 'package:shared/src/converters/stacktrace.converter.dart';
import 'package:shared/src/converters/version.converter.dart';
import 'package:test/test.dart';

void main() {
  group('StackTraceConverter', () {
    test('toJson and fromJson keep stack trace string content', () {
      const converter = StackTraceConverter();
      final trace = StackTrace.fromString('line_a\nline_b');

      final json = converter.toJson(trace);
      final parsed = converter.fromJson(json);

      expect(json, contains('line_a'));
      expect(parsed.toString(), contains('line_b'));
    });
  });

  group('VersionConverter', () {
    test('fromJson parses semantic version text', () {
      const converter = VersionConverter();

      final version = converter.fromJson('1.2.3.dev');

      expect(version.major, 1);
      expect(version.minor, 2);
      expect(version.patch, 3);
      expect(version.build, 'dev');
    });

    test('toJson serializes IVersion to string', () {
      const converter = VersionConverter();
      const version = Version(major: 2, minor: 5, patch: 9, build: 'beta');

      expect(converter.toJson(version), '2.5.9.beta');
    });
  });
}
