// class AuthService {
//   final UserRepository users;
//   final Map<String, AuthConfigProvider> providers;
//   final JwtService jwt;
//
//   Future<LoginResponse> login(
//     String providerId,
//     AuthRequest request,
//   ) async {
//     final provider = providers[providerId]!;
//
//     final authResult = await provider.authenticate(request);
//
//     final user = await users.findOrCreateFromAuth(
//       providerId: providerId,
//       externalId: authResult.externalUserId,
//       email: authResult.email,
//       displayName: authResult.displayName,
//     );
//
//     final token = jwt.issueToken(user);
//
//     return LoginResponse(
//       accessToken: token,
//       user: user.toDto(),
//     );
//   }
// }
