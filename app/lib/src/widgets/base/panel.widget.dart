import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/models/layout/layout.dart';
import 'package:casa/src/widgets/base/layoutbuilder.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';

Future<T?> showPanel<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  EPanelSize size = EPanelSize.small,
  bool barrierDismissible = true,
  bool enableTopPadding = false,
  double topPadding = kToolbarHeight,
}) {
  return Navigator.of(context).push(
    _CasaPanelRoute<T>(
      child: child,
      title: title,
      size: size,
      barrierDismissible: barrierDismissible,
      enableTopPadding: enableTopPadding,
      topPadding: topPadding,
    ),
  );
}

class _CasaPanelRoute<T> extends PageRoute<T> {
  // region Parameters

  final Widget child;

  final String? title;

  final EPanelSize size;

  final bool _barrierDismissible;

  final bool enableTopPadding;

  final double topPadding;

  // endregion

  // region Constructors

  _CasaPanelRoute({
    required this.child,
    this.title,
    bool barrierDismissible = true,
    this.size = EPanelSize.small,
    this.enableTopPadding = false,
    this.topPadding = kToolbarHeight,
  }) : _barrierDismissible = barrierDismissible;

  // endregion

  // region Getter

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  Color get barrierColor => Colors.grey.withValues(alpha: 0.3);

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  // endregion

  // region Methods

  double _calculateWidth(Layout layout) {
    switch (size) {
      case EPanelSize.small:
        return layout.width > 900 ? 420.0 : layout.width;
      case EPanelSize.medium:
        return layout.width > 900 ? 600.0 : layout.width;
      case EPanelSize.large:
        return layout.width > 900 ? 800.0 : layout.width;
      case EPanelSize.extraLarge:
        return layout.width > 900 ? 1000.0 : layout.width;
      case EPanelSize.fullWidth:
        return layout.width;
    }
  }

  // endregion

  // region Widgets

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: CasaText(
              title ?? 'Panel',
              style: context.theme.textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final offsetAnimation =
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  // endregion

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CasaLayoutBuilder(
      builder: (context, layout) {
        final panelWidth = _calculateWidth(layout);

        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: enableTopPadding ? EdgeInsets.only(top: topPadding) : EdgeInsets.zero,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: Material(
                color: context.theme.colorScheme.surface,
                elevation: 16,
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
