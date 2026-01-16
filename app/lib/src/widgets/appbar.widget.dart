import 'package:flutter/material.dart';

class CasaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CasaAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
