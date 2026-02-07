import 'package:casa/src/core/interfaces/auth/i_token_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InMemoryAuthTokenProvider implements ITokenProvider {
  String? _token;

  final FlutterSecureStorage _storage;

  InMemoryAuthTokenProvider(this._token, this._storage);

  InMemoryAuthTokenProvider.empty(FlutterSecureStorage storage) : this(null, storage);

  @override
  Future<String?> get accessToken async {
    if (_token != null) {
      return _token;
    }

    return _storage.read(key: 'casa.jwt');
  }

  @override
  bool get hasToken => _token != null;

  @override
  void setAccessToken(String? token) {
    _token = token;
  }

  @override
  ITokenProvider copyWith({String? accessToken}) {
    return InMemoryAuthTokenProvider(accessToken ?? _token, _storage);
  }
}
