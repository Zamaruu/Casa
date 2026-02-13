import 'dart:convert';
import 'dart:math';

import 'package:casa_api/src/interfaces/auth/i_api_key_authenticator.dart';
import 'package:crypto/crypto.dart';
import 'package:shared/shared.dart';

class ApiKeyService implements IApiKeyAuthenticator {
  final IApiKeyOperations keyOperations;

  const ApiKeyService({
    required this.keyOperations,
  });

  @override
  String generateRawApiKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));

    return 'casa_live_${base64Url.encode(bytes)}';
  }

  @override
  String hashApiKey(String rawKey) {
    final bytes = utf8.encode(rawKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<IApiKey?> authenticate(String rawKey) async {
    final hash = hashApiKey(rawKey);
    final apiKeyResponse = await keyOperations.findByHash(hash);

    if (apiKeyResponse.isError || apiKeyResponse.hasValue == false) return null;

    final apiKey = apiKeyResponse.value!;

    if (apiKey.revokedAt != null) return null;
    if (apiKey.expiresAt?.isBefore(DateTime.now()) ?? false) return null;

    await keyOperations.updateLastUsed(apiKey.id);

    return apiKey;
  }
}
