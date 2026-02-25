import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/interfaces/menu/i_menu_item.dart';
import 'package:casa/src/core/models/enums/e_screen_type.dart';
import 'package:casa/src/core/models/layout/layout.dart';
import 'package:casa/src/core/utils/menu.util.dart';
import 'package:casa/src/widgets/base/appbar.widget.dart';
import 'package:casa/src/widgets/base/drawer.widget.dart';
import 'package:casa/src/widgets/base/fab.widget.dart';
import 'package:casa/src/widgets/base/layoutbuilder.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/menu/menubar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'package:universal_platform/universal_platform.dart';

class CasaScaffold<R extends IResponse> extends ConsumerStatefulWidget {
  final String title;

  final Widget Function(BuildContext context, WidgetRef ref, Layout layout)? builder;

  /// When runFutureOnce is true, the [future] will only be executed the first time the scaffold is build.
  final bool runFutureOnce;

  final Future<R>? future;

  final Widget Function(BuildContext context, WidgetRef ref, R futureResponse, Layout layout)? futureBuilder;

  /// A function that will be executed on the first render after the future was run.
  final void Function(BuildContext context, WidgetRef ref, R futureResponse)? runAfterFuture;

  /// The menu items to be displayed as commandbar or multifab, depending on device layout
  final IMenu? menu;

  final bool showMenuItems;

  final Widget? bottomNavigationBar;

  final bool showAppBar;

  final EdgeInsetsGeometry? bodyPadding;

  // region Constructors

  const CasaScaffold({
    super.key,
    required this.title,
    this.builder,
    this.future,
    this.futureBuilder,
    this.menu,
    this.showMenuItems = true,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.bodyPadding,
    this.runFutureOnce = false,
    this.runAfterFuture,
  }) : assert(builder != null || futureBuilder != null, 'Either builder or futureBuilder must be provided');

  const CasaScaffold.builder({
    super.key,
    required this.title,
    required this.builder,
    this.menu,
    this.showMenuItems = true,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.bodyPadding,
  }) : future = null,
       futureBuilder = null,
       runAfterFuture = null,
       runFutureOnce = false;

  const CasaScaffold.future({
    super.key,
    required this.title,
    required this.future,
    required this.futureBuilder,
    this.menu,
    this.showMenuItems = true,
    this.bottomNavigationBar,
    this.showAppBar = true,
    this.bodyPadding,
    this.runFutureOnce = false,
    this.runAfterFuture,
  }) : builder = null;

  // endregion

  @override
  ConsumerState<CasaScaffold> createState() => _CasaScaffoldState<R>();
}

class _CasaScaffoldState<R extends IResponse> extends ConsumerState<CasaScaffold<R>> {
  // region State-Parameters

  late List<IMenuItem> navigationItems;

  late List<IMenuItem> serviceItems;

  late Widget profileItem;

  late final Future<R>? future;

  // endregion

  // region Lifecycle

  @override
  void initState() {
    super.initState();

    final menuUtils = MenuUtils();

    if (widget.runFutureOnce) {
      future = widget.future;
    }

    navigationItems = menuUtils.buildDrawerItems(context);
    serviceItems = menuUtils.buildServiceItems(ref);
    profileItem = menuUtils.buildProfile(context, ref.read(authProvider).asData!.value.user!);
  }

  // endregion

  // region Widgets

  Widget buildContent(Widget child, Layout layout) {
    return Padding(
      padding: widget.bodyPadding ?? EdgeInsets.all(UniversalPlatform.isWeb ? 16 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (layout.screenType != EScreenType.mobil) buildCommandBar(),

          Expanded(child: child),
        ],
      ),
    );
  }

  Widget buildCommandBar() {
    if (widget.menu != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Menubar(menu: widget.menu!),
          SizedBox(height: UniversalPlatform.isWeb ? 16 : 8),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return CasaLayoutBuilder(
      builder: (context, layout) {
        return Scaffold(
          appBar: widget.showAppBar ? CasaAppBar(title: widget.title) : null,
          drawer: CasaDrawer(
            items: navigationItems,
            service: serviceItems,
            header: profileItem,
          ),
          body: Builder(
            builder: (context) {
              late Widget content;

              if (widget.builder != null) {
                content = widget.builder!(context, ref, layout);
              } else if (widget.futureBuilder != null) {
                content = FutureBuilder(
                  future: widget.runFutureOnce ? future : widget.future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: CasaText('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final futureResponse = snapshot.data!;

                      if (widget.runAfterFuture != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.runAfterFuture!(context, ref, futureResponse);
                        });
                      }

                      return widget.futureBuilder!(context, ref, futureResponse, layout);
                    } else {
                      return const Center(child: CasaText('No data available'));
                    }
                  },
                );
              } else {
                content = const Center(child: CasaText('No content available'));
              }

              return buildContent(content, layout);
            },
          ),
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: widget.menu != null && layout.screenType == EScreenType.mobil
              ? CasaFab.multiple(items: widget.menu!.items)
              : null,
        );
      },
    );
  }
}
