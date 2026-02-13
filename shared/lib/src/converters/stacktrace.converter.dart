import 'package:json_annotation/json_annotation.dart';

class StackTraceConverter extends JsonConverter<StackTrace, String> {
  const StackTraceConverter();

  @override
  StackTrace fromJson(String json) {
    return StackTrace.fromString(json);
  }

  @override
  String toJson(StackTrace object) {
    return object.toString();
  }
}
