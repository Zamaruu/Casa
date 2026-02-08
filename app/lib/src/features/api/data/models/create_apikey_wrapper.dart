import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

part 'create_apikey_wrapper.g.dart';

@JsonSerializable()
class CreateApiKeyWrapper implements ISerializable {
  final String rawKey;

  final ApiKey keyInfos;

  const CreateApiKeyWrapper({
    required this.rawKey,
    required this.keyInfos,
  });

  // region Serialization

  factory CreateApiKeyWrapper.fromJson(Map<String, dynamic> json) => _$CreateApiKeyWrapperFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateApiKeyWrapperToJson(this);

  // endregion
}
