import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/shared.dart';

class JwtService {
  final String secret;
  final Duration tokenLifetime;

  JwtService({
    required this.secret,
    required this.tokenLifetime,
  });

  String generate(IUser user) {
    final jwt = JWT(
      {
        'id': user.id,
        'email': user.email,
        'username': user.username,
        'groups': user.groups,
        'createdAt': user.createdAt?.toIso8601String(),
        'updatedAt': user.updatedAt?.toIso8601String(),
      },
      issuer: 'casa-api',
      subject: user.id,
    );

    return jwt.sign(
      SecretKey(secret),
      expiresIn: tokenLifetime,
    );
  }
}
