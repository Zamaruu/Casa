/// Contract for objects that can serialize themselves into JSON-like maps.
abstract interface class ISerializable {
  /// Converts the current object to a Map which can be serialized to JSON.
  ///
  /// Returns `Map<String, dynamic>`.
  Map<String, dynamic> toJson();
}
