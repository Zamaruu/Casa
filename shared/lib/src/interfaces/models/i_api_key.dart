import 'package:shared/shared.dart';

abstract interface class IApiKey implements IEntity {
  String get name;

  String? get description;

  String get keyHash;

  DateTime? get expiresAt;

  DateTime? get revokedAt;

  DateTime? get lastUsedAt;

  List<String> get scopes;
}
