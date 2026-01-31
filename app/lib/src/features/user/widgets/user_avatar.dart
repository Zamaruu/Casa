import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class UserAvatar extends StatelessWidget {
  final IUser user;

  final double fontSize;

  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.onTap,
    this.fontSize = 24.0,
    required this.user,
  });

  // region Methods

  /// Generates a (random) color based on the user's id.
  ///
  /// The color will always be the same for the same user.
  /// If the user's id is null, a random color is generated.
  Color get _colorBasedOnId {
    final id = user.id;
    if (id.isEmpty) {
      return Colors.grey;
    }

    final hash = id.hashCode;
    final hue = (hash % 360).toDouble();
    final color = HSLColor.fromAHSL(1, hue, 0.5, 0.5).toColor();

    return color;
  }

  /// Return the initial charachters of the user's name and capitalizes them.
  ///
  /// If the user's name is null, an empty string is returned.
  String get _initials {
    final name = user.username;
    if (name.isEmpty) {
      return "";
    }

    final parts = name.split(" ");
    final initials = parts.map((part) => part[0].toUpperCase()).join();

    return initials;
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(90),
      child: CircleAvatar(
        foregroundColor: _colorBasedOnId,
        child: Center(
          child: Text(
            _initials,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
