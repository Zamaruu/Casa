import 'package:shared/src/interfaces/misc/i_serializable.dart';

/// Semantic version contract.
abstract interface class IVersion implements ISerializable {
  /// Main feature version indicator
  ///
  /// Returns `int`.
  int get major;

  /// Smaller feature version updates
  ///
  /// Returns `int`.
  int get minor;

  /// Bug and hot fixes
  ///
  /// Returns `int`.
  int get patch;

  /// Build suffix (e.g. "dev" or "beta")
  ///
  /// Returns `String`.
  String get build;
}
