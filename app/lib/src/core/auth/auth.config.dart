class AuthConfig {
  static const clientId = 'casa-app';
  static const redirectUri = 'casa://auth/callback';

  static const authorizationEndpoint = 'https://auth.example.com/application/o/authorize/';
  static const tokenEndpoint = 'https://auth.example.com/application/o/token/';

  static const scopes = ['openid', 'profile', 'email'];
}
