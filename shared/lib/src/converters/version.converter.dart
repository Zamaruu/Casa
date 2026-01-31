import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

class VersionConverter extends JsonConverter<IVersion, String> {
  const VersionConverter();

  @override
  IVersion fromJson(json) {
    return Version.fromString(json);
  }

  @override
  String toJson(IVersion object) {
    return object.toString();
  }
}
