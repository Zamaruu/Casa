import 'package:json_annotation/json_annotation.dart';
import 'package:shared/src/abstract/entity.dart';
import 'package:shared/src/interfaces/models/i_api_key.dart';

part 'api_key.model.g.dart';

@JsonSerializable()
class ApiKey extends Entity implements IApiKey {
  // region Parameters

  @override
  final String name;

  @override
  final String? description;

  @override
  final String keyHash;

  @override
  final DateTime? expiresAt;

  @override
  final DateTime? revokedAt;

  @override
  final DateTime? lastUsedAt;

  @override
  final List<String> scopes;

  // endregion

  // region Constructors

  const ApiKey({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.description,
    required this.keyHash,
    this.expiresAt,
    this.revokedAt,
    this.lastUsedAt,
    this.scopes = const [],
  });

  // endregion

  // region Serialization

  @override
  Map<String, dynamic> toJson() => _$ApiKeyToJson(this);

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);

  // endregion

  // region Methods

  @override
  IApiKey copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
    String? keyHash,
    DateTime? expiresAt,
    DateTime? revokedAt,
    DateTime? lastUsedAt,
    List<String>? scopes,
  }) {
    return ApiKey(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      keyHash: keyHash ?? this.keyHash,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      scopes: scopes ?? this.scopes,
    );
  }

  // endregion
}
