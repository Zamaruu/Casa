abstract interface class ISerializable {
  /// Converts the current object to a Map which can be serialized to JSON.
  Map<String, dynamic> toJson();
}
