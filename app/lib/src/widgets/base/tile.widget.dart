import 'package:flutter/material.dart';

class CasaTile extends StatelessWidget {
  final Widget title;

  final Widget? leading;

  final Widget? subtitle;

  final Widget? thirdTitle;

  final Widget? trailing;

  final VoidCallback? onTap;

  const CasaTile({
    super.key,
    required this.title,
    this.leading,
    this.onTap,
    this.subtitle,
    this.thirdTitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: title,
      leading: leading,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          subtitle ?? const SizedBox.shrink(),
          thirdTitle ?? const SizedBox.shrink(),
        ],
      ),
      trailing: trailing,
    );
  }
}
