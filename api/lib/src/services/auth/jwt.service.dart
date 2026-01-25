import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/shared.dart';

class JwtService {
  final String secret;
  final Duration tokenLifetime;

  JwtService({
    required this.secret,
    required this.tokenLifetime,
  });

  String get issuer => 'casa-api';

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
      issuer: issuer,
      subject: user.id,
    );

    return jwt.sign(
      SecretKey(secret),
      expiresIn: tokenLifetime,
    );
  }

  Map<String, dynamic> verify(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(secret),
      issuer: issuer,
    );

    return jwt.payload as Map<String, dynamic>;
  }
}
