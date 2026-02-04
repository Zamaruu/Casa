import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';

/// Structure of user actions of a specific route.
///
/// Depending on device orientation and layout, they could be displayed as a Menubar or a Multi-FAB.
abstract interface class IMenu {
  /// Normal menu items to be displayed in the Menu-Bar.
  ///
  /// Depending on device orientation and layout, they could be displayed together with [overflowItems].
  List<IMenuItem> get mainItems;

  /// Menu items to be directly placed in a pop-up menu.
  ///
  /// Depending on device orientation and layout, they could be displayed together with [mainItems].
  List<IMenuItem> get overflowItems;

  /// Menu items to be displayed with a spacer between them and [mainItems] / [overflowItems].
  List<IMenuItem> get farItems;

  /// Combination of all menu items in [mainItems], [overflowItems] and [farItems].
  List<IMenuItem> get items;
}
