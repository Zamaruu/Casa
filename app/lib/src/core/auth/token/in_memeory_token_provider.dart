import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';

class InMemoryAuthTokenProvider implements ITokenProvider {
  String? _token;

  InMemoryAuthTokenProvider(this._token);

  InMemoryAuthTokenProvider.empty() : this(null);

  @override
  String? get accessToken => _token;

  @override
  bool get hasToken => accessToken != null;

  @override
  void setAccessToken(String? token) {
    _token = token;
  }

  @override
  ITokenProvider copyWith({String? accessToken}) {
    return InMemoryAuthTokenProvider(accessToken ?? this.accessToken);
  }
}
