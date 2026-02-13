import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/extensions/datetime.extensions.dart';
import 'package:casa/src/core/interfaces/menu/i_menu.dart';
import 'package:casa/src/core/models/menus/menu.dart';
import 'package:casa/src/core/models/menus/menu_item.dart';
import 'package:casa/src/core/router/casa_navigator.dart';
import 'package:casa/src/features/logs/data/provider/errorlogs_list_provider.dart';
import 'package:casa/src/features/logs/data/utils/errorlog.util.dart';
import 'package:casa/src/widgets/base/scaffold.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:casa/src/widgets/base/tile.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class ErrorLogsRoute extends ConsumerStatefulWidget {
  const ErrorLogsRoute({super.key});

  @override
  ConsumerState<ErrorLogsRoute> createState() => _ErrorLogsRouteState();
}

class _ErrorLogsRouteState extends ConsumerState<ErrorLogsRoute> {
  late final IMenu menu;

  late final ErrorLogUtil errorLogUtil;

  // region LifeCycle

  @override
  void initState() {
    super.initState();
    menu = setupMenu();
    errorLogUtil = const ErrorLogUtil();
  }

  // endregion

  // region Methods

  IMenu setupMenu() {
    return Menu(
      mainItems: [
        MenuItem(
          title: "Aktualisieren",
          icon: Icons.refresh,
          onTap: () => ref.invalidate(errorLogsListProvider),
        ),
        MenuItem(
          title: "Herunterladen",
          icon: Icons.download,
          onTap: () {},
        ),
        MenuItem(
          title: "Suchen",
          icon: Icons.search,
          onTap: () {},
        ),
      ],
      farItems: [
        MenuItem.icon(
          icon: Icons.filter_alt_outlined,
          onTap: () {},
        ),
        MenuItem.icon(
          icon: Icons.dashboard_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return CasaScaffold<IValueResponse<List<IErrorLog>>>.future(
      title: "Fehlermeldungen",
      showAppBar: false,
      future: ref.watch(errorLogsListProvider.future),
      menu: menu,
      futureBuilder: (context, ref, response, layout) {
        if (response.isSuccess && response.hasValue) {
          final errorLogs = response.value!;

          if (errorLogs.isEmpty) {
            return Center(
              child: CasaText("Keine Fehlermeldungen gefunden"),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: errorLogs.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final errorLog = errorLogs[index];
                  return CasaTile(
                    leading: Icon(Icons.error_outline),
                    title: CasaText(errorLog.title),
                    subtitle: CasaText(errorLog.message),
                    thirdTitle: CasaText(errorLog.id),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (errorLog.createdAt != null)
                          CasaText(
                            errorLog.createdAt!.toDateTimeString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        IconButton(
                          onPressed: () => CasaNavigator.go(context, "/admin/logging/${errorLog.id}"),
                          color: context.theme.primaryColor,
                          icon: const Icon(Icons.info_outline),
                          tooltip: "Details about ${errorLog.title}",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          return Center(
            child: CasaText("No ErrorLogs found"),
          );
        }
      },
    );
  }
}
