import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:casa/src/core/auth/auth.provider.dart';
import 'package:casa/src/core/utils/menu.util.dart';
import 'package:casa/src/widgets/base/appbar.widget.dart';
import 'package:casa/src/widgets/base/drawer.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class CasaScaffold<R extends IResponse> extends ConsumerStatefulWidget {
  final String title;

  final Widget Function(BuildContext context, WidgetRef ref)? builder;

  final Future<R>? future;

  final Widget Function(BuildContext context, WidgetRef ref, R futureResponse)? futureBuilder;

  final List<IMenuItem> menuItems;

  // region Constructors

  const CasaScaffold({
    super.key,
    required this.title,
    this.builder,
    this.future,
    this.futureBuilder,
    this.menuItems = const [],
  }) : assert(builder != null || futureBuilder != null, 'Either builder or futureBuilder must be provided');

  const CasaScaffold.builder({
    super.key,
    required this.title,
    required this.builder,
    this.menuItems = const [],
  }) : future = null,
       futureBuilder = null;

  const CasaScaffold.future({
    super.key,
    required this.title,
    required this.future,
    required this.futureBuilder,
    this.menuItems = const [],
  }) : builder = null;

  // endregion

  @override
  ConsumerState<CasaScaffold> createState() => _CasaScaffoldState<R>();
}

class _CasaScaffoldState<R extends IResponse> extends ConsumerState<CasaScaffold<R>> {
  late List<IMenuItem> navigationItems;

  late List<IMenuItem> serviceItems;

  late Widget profileItem;

  late final Future<R>? future;

  @override
  void initState() {
    super.initState();

    final menuUtils = MenuUtils();

    future = widget.future;

    navigationItems = menuUtils.buildDrawerItems(context);
    serviceItems = menuUtils.buildServiceItems(ref);
    profileItem = menuUtils.buildProfile(context, ref.read(authProvider).asData!.value.user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CasaAppBar(title: widget.title),
      drawer: CasaDrawer(
        items: navigationItems,
        service: serviceItems,
        header: profileItem,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(
          builder: (context) {
            if (widget.builder != null) {
              return widget.builder!(context, ref);
            } else if (future != null && widget.futureBuilder != null) {
              return FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: CasaText('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final futureResponse = snapshot.data!;

                    return widget.futureBuilder!(context, ref, futureResponse);
                  } else {
                    return const Center(child: CasaText('No data available'));
                  }
                },
              );
            } else {
              throw Exception('Either builder or futureBuilder must be provided');
            }
          },
        ),
      ),
    );
  }
}
