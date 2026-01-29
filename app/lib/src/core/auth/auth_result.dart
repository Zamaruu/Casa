class AuthResult {
  final String externalUserId;
  final String email;
  final String? displayName;

  AuthResult({
    required this.externalUserId,
    required this.email,
    this.displayName,
  });
}
