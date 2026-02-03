import 'package:shared/shared.dart';

abstract interface class IDeserializer<T extends IEntity> {
  T fromJson(Map<String, dynamic> json);
}
