import 'package:casa_api/src/interfaces/auth/i_user_authenticator.dart';
import 'package:casa_api/src/utils/logger.util.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared/shared.dart';

class JwtService implements IUserAuthenticator {
  final String secret;
  final Duration tokenLifetime;

  JwtService({
    required this.secret,
    required this.tokenLifetime,
  });

  String get issuer => 'casa-api';

  @override
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

  @override
  Future<IUser?> authenticate(String jwt) async {
    try {
      final token = JWT.verify(
        jwt,
        SecretKey(secret),
        issuer: issuer,
      );

      final claims = token.payload as Map<String, dynamic>;
      final user = User.fromJson(claims);

      return user;
    } on JWTInvalidException catch (e, st) {
      final message = 'Invalid JWT token received, cannot authenticate user.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return null;
    } catch (e, st) {
      final message = 'Unexpected error catched while authenticating user with JWT claims.';
      apiLog(message: message, error: e, stackTrace: st, callingClass: runtimeType);
      return null;
    }
  }
}
