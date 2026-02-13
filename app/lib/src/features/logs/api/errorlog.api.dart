import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/features/logs/data/interfaces/i_errorlog.api.dart';
import 'package:shared/shared.dart';

class ErrorLogApi extends TypedApiManager<IErrorLog> implements IErrorLogApi {
  @override
  String get controller => EApiController.errorLogs.endpoint;

  ErrorLogApi(super.client);

  @override
  IErrorLog fromJson(Map<String, dynamic> json) {
    return ErrorLog.fromJson(json);
  }
}
