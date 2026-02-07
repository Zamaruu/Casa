import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  // reigon Parameters

  final IconData? icon;

  final String label;

  final VoidCallback? onPressed;

  final bool loading;

  // endregion

  // region Constructors

  const PrimaryButton({
    super.key,
    this.icon,
    this.onPressed,
    this.loading = false,
    required this.label,
  });

  const PrimaryButton.icon({
    super.key,
    required IconData this.icon,
    required this.label,
    this.onPressed,
    this.loading = false,
  });

  // endregion

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon),
          SizedBox(width: 8),
          Text(label),
          if (loading) SizedBox(width: 8),
          if (loading) CircularProgressIndicator(),
        ],
      ),
    );
  }
}
