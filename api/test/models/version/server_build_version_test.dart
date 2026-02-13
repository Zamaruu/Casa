import 'package:casa_api/src/models/version/server_build_version.dart';
import 'package:test/test.dart';

void main() {
  group('ServerBuildVersion', () {
    test('fromEnvironment creates non-empty metadata with defaults', () {
      final info = ServerBuildVersion.fromEnvironment();

      expect(info.version.toString(), isNotEmpty);
      expect(info.minimumAppVersion.toString(), isNotEmpty);
      expect(info.buildDate, isNotEmpty);
      expect(info.environment, isNotEmpty);
      expect(info.platform, isNotEmpty);
    });

    test('json roundtrip keeps key fields', () {
      final info = ServerBuildVersion.fromEnvironment();
      final json = info.toJson();
      final parsed = ServerBuildVersion.fromJson(json);

      expect(parsed.version.toString(), info.version.toString());
      expect(parsed.minimumAppVersion.toString(), info.minimumAppVersion.toString());
      expect(parsed.commit, info.commit);
    });
  });
}
