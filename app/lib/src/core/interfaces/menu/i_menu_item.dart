import 'package:flutter/material.dart';

abstract interface class IMenuItem {
  String get title;

  IconData get icon;

  VoidCallback get onTap;

  List<IMenuItem> get children;

  bool get isIconOnly;
}
