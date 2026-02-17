import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter extends JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    final decode = base64Decode(json);
    return decode;
  }

  @override
  String toJson(Uint8List object) {
    final encode = base64Encode(object);
    return encode;
  }
}
