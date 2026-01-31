import 'package:casa/src/core/interfaces/i_api.dart';
import 'package:casa/src/core/interfaces/i_api_response.dart';
import 'package:shared/shared.dart';

abstract interface class IMetaApi implements IApi {
  @override
  Future<IResponse> healthcheck();

  @override
  Future<IApiResponse<IServerVersionInfo>> version();
}
