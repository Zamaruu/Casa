import 'package:casa/src/core/interfaces/menu/i_base_menu_item.dart';
import 'package:flutter/material.dart';

abstract interface class IMenuItem implements IBaseMenuItem {
  VoidCallback get onTap;

  List<IMenuItem> get children;
}
