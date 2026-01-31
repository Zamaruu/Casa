import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

part 'version.g.dart';

@JsonSerializable()
class Version implements IVersion {
  @override
  final int major;

  @override
  final int minor;

  @override
  final int patch;

  @override
  final String build;

  // region Constructors

  const Version({
    required this.major,
    required this.minor,
    required this.patch,
    this.build = "",
  });

  factory Version.empty() {
    return const Version(
      major: 0,
      minor: 0,
      patch: 0,
    );
  }

  factory Version.fromString(String version) {
    final parts = version.split(".");

    final major = int.parse(parts[0]);
    final minor = int.parse(parts[1]);
    final patch = int.parse(parts[2]);
    final build = parts.length > 3 ? parts[3] : "";

    return Version(
      major: major,
      minor: minor,
      patch: patch,
      build: build,
    );
  }

  // endregion

  // region Operator Overloading

  bool operator >(Version other) {
    if (major > other.major) {
      return true;
    } else if (major == other.major) {
      if (minor > other.minor) {
        return true;
      } else if (minor == other.minor) {
        if (patch > other.patch) {
          return true;
        } else if (patch == other.patch) {
          if (build.isNotEmpty && other.build.isEmpty) {
            return true;
          }
        }
        return false;
      }
      return false;
    }
    return false;
  }

  bool operator >=(Version other) {
    if (major > other.major) {
      return true;
    } else if (major == other.major) {
      if (minor > other.minor) {
        return true;
      } else if (minor == other.minor) {
        if (patch > other.patch) {
          return true;
        } else if (patch == other.patch) {
          if (build.isNotEmpty && other.build.isEmpty) {
            return true;
          }
        }
        return false;
      }
      return false;
    }
    return false;
  }

  bool operator <(Version other) {
    if (major < other.major) {
      return true;
    } else if (major == other.major) {
      if (minor < other.minor) {
        return true;
      } else if (minor == other.minor) {
        if (patch < other.patch) {
          return true;
        } else if (patch == other.patch) {
          if (build.isNotEmpty && other.build.isEmpty) {
            return true;
          }
        }
        return false;
      }
      return false;
    } else {
      return false;
    }
  }

  bool operator <=(Version other) {
    if (major < other.major) {
      return true;
    } else if (major == other.major) {
      if (minor < other.minor) {
        return true;
      } else if (minor == other.minor) {
        if (patch < other.patch) {
          return true;
        } else if (patch == other.patch) {
          if (build.isNotEmpty && other.build.isEmpty) {
            return true;
          }
        }
        return false;
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Version) {
      return major == other.major && minor == other.minor && patch == other.patch && build == other.build;
    } else {
      return false;
    }
  }

  // endregion

  // region JsonSerializable

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VersionToJson(this);

  // endregion

  // region Methods

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() {
    final buffer = StringBuffer();

    buffer.write(major);
    buffer.write(".");
    buffer.write(minor);
    buffer.write(".");
    buffer.write(patch);

    if (build.isNotEmpty) {
      buffer.write(".");
      buffer.write(build);
    }

    return buffer.toString();
  }

  // endregion
}
