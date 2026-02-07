import 'package:casa/src/core/interfaces/menu/i_base_menu_item.dart';

abstract interface class IRoutableMenuItem implements IBaseMenuItem {
  String get route;
}
