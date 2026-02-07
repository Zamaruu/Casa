import 'package:casa/src/core/api/typed_api_manager.dart';
import 'package:casa/src/features/user/data/interfaces/i_user.api.dart';
import 'package:shared/shared.dart';

class UserApi extends TypedApiManager<IUser> implements IUserApi {
  @override
  String get controller => EApiController.user.endpoint;

  UserApi(super.client);

  @override
  IUser fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
