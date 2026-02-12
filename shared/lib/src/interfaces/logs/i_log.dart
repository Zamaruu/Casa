import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_feature.dart';

abstract interface class ILog implements IEntity {
  String get title;

  String get message;

  ELogLevel get logLevel;

  EFeature get feature;

  String? get userId;

  String? get correlationId;
}
