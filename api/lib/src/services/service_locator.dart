import 'package:api/src/database/database.service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final services = GetIt.instance;

extension ServiceExtensions on GetIt {
  IServiceCollection<Type, IDefaultEntityOperations> get database => get<DatabaseServiceCollection>();
}
