class AuthConfig {
  final String jwtSecret;

  final Duration expiresIn;

  AuthConfig({required this.jwtSecret, required this.expiresIn});
}
