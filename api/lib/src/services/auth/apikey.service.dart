import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class ApiKeyService {
  const ApiKeyService();

  String generateRawApiKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));

    return 'casa_live_${base64Url.encode(bytes)}';
  }

  String hashApiKey(String rawKey) {
    final bytes = utf8.encode(rawKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
