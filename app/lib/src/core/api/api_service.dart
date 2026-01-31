import 'package:casa/src/core/api/api_client.dart';
import 'package:casa/src/core/interfaces/i_api.dart';
import 'package:casa/src/features/auth/api/auth.api.dart';
import 'package:casa/src/features/auth/data/interfaces/i_auth_api.dart';
import 'package:casa/src/features/infos/api/meta.api.dart';
import 'package:casa/src/features/infos/data/interfaces/i_meta_api.dart';
import 'package:shared/shared.dart';

class ApiServiceManager extends ServiceCollection<Type, IApi> {
  final ApiClient client;

  ApiServiceManager({required this.client});

  @override
  Future<void> initalize() async {
    addAll({
      IAuthApi: AuthApi(client),
      IMetaApi: MetaApi(client),
    });
  }
}
