import 'package:dotenv/dotenv.dart';

class ConfigLoader {
  static Map<String, String> load() {
    final env = DotEnv(includePlatformEnvironment: true);

    // .env nur optional laden (Docker braucht sie nicht)
    env.load();

    return Map<String, String>.from(env.map);
  }
}
