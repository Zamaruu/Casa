import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:casa/src/core/models/enums/e_menu_bar_item_type.dart';

abstract interface class IMenuBarItem implements IMenuItem {
  EMenuBarItemType get type;
}
