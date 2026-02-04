import 'package:flutter/material.dart';

abstract interface class IBaseMenuItem {
  String get title;

  IconData get icon;

  bool get isIconOnly;
}
