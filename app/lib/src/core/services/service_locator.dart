import 'package:casa/src/core/api/api_service.dart';
import 'package:casa/src/core/interfaces/i_api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final services = GetIt.instance;

extension ServiceExtensions on GetIt {
  IServiceCollection<Type, IApi> get api => get<ApiServiceManager>();
}
