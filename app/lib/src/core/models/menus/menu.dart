import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';

class Menu implements IMenu {
  @override
  final List<IMenuItem> mainItems;

  @override
  final List<IMenuItem> overflowItems;

  @override
  final List<IMenuItem> farItems;

  const Menu({
    this.mainItems = const [],
    this.overflowItems = const [],
    this.farItems = const [],
  });

  @override
  List<IMenuItem> get items => [
    ...mainItems,
    ...overflowItems,
    ...farItems,
  ];
}
