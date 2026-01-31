import 'package:shared/src/interfaces/i_serializable.dart';

abstract interface class IVersion implements ISerializable {
  /// Main feature version indicator
  int get major;

  /// Smaller feature version updates
  int get minor;

  /// Bug and hot fixes
  int get patch;

  /// Build suffix (e.g. "dev" or "beta")
  String get build;
}
