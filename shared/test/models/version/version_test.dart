import 'package:shared/shared.dart';
import 'package:test/test.dart';

void main() {
  group('Version', () {
    test('fromString parses semantic versions with and without build suffix', () {
      final plain = Version.fromString('1.2.3');
      final withBuild = Version.fromString('1.2.3.dev');

      expect(plain.major, 1);
      expect(plain.minor, 2);
      expect(plain.patch, 3);
      expect(plain.build, '');

      expect(withBuild.build, 'dev');
    });

    test('toString serializes back to semantic format', () {
      const plain = Version(major: 1, minor: 0, patch: 4);
      const withBuild = Version(major: 1, minor: 0, patch: 4, build: 'beta');

      expect(plain.toString(), '1.0.4');
      expect(withBuild.toString(), '1.0.4.beta');
    });

    test('comparison operators compare numeric parts', () {
      const lower = Version(major: 1, minor: 2, patch: 3);
      const higher = Version(major: 1, minor: 2, patch: 4);

      expect(higher > lower, isTrue);
      expect(lower < higher, isTrue);
      expect(lower > higher, isFalse);
      expect(higher < lower, isFalse);
    });

    test('equality and hashCode are value based', () {
      const a = Version(major: 2, minor: 1, patch: 0, build: 'dev');
      const b = Version(major: 2, minor: 1, patch: 0, build: 'dev');
      const c = Version(major: 2, minor: 1, patch: 1, build: 'dev');

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
    });

    test('json roundtrip keeps values', () {
      const version = Version(major: 3, minor: 2, patch: 1, build: 'rc');
      final json = version.toJson();
      final parsed = Version.fromJson(json);

      expect(parsed, version);
    });
  });
}
