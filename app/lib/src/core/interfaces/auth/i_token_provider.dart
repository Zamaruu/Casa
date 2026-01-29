import 'package:shared/shared.dart';

abstract interface class ITokenProvider implements ICopyable<ITokenProvider> {
  String? get accessToken;

  bool get hasToken;

  void setAccessToken(String? token);

  @override
  ITokenProvider copyWith({String? accessToken});
}
