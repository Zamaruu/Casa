import 'package:api/src/services/auth/jwt.service.dart';
import 'package:shared/shared.dart';

class ApiAuthService implements IAuthService {
  final PasswordHasher hasher;

  final JwtService jwtService;

  final IUserOperations userOperations;

  const ApiAuthService({
    this.hasher = const PasswordHasher(),
    required this.userOperations,
    required this.jwtService,
  });

  @override
  IUser fromClaims(Map<String, dynamic> claims) {
    return User.fromJson(claims);
  }

  @override
  String hashPassword(String password) {
    return hasher.hash(password);
  }

  @override
  bool verifyPassword(String password, String hash) {
    return hasher.verify(password, hash);
  }

  @override
  Future<IValueResponse<String>> authenticate(String email, String password) async {
    try {
      final userResponse = await userOperations.findByEmail(email);

      if (userResponse.isError || userResponse.hasValue == false) {
        return ValueResponse.failure(
          message: userResponse.message,
          error: userResponse.error,
          stackTrace: userResponse.stackTrace,
        );
      }

      final user = userResponse.value!;
      final passwordHash = user.passwordHash;

      final valid = verifyPassword(password, passwordHash);

      if (!valid) {
        return ValueResponse.failure(message: 'Invalid password');
      }

      final token = jwtService.generate(user);

      return ValueResponse.success(value: token);
    } catch (e, st) {
      return ValueResponse.failure(
        message: 'Error while authenticating',
        error: e,
        stackTrace: st,
      );
    }
  }
}
