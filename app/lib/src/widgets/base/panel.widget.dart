import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/models/layout/layout.dart';
import 'package:casa/src/widgets/base/layoutbuilder.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';

_CasaPanelRoute<dynamic>? _activePanelRoute;

/// Shows a panel in the right center of the screen with a fade-in and fade-out animation.
Future<T?> showPanel<T>({
  required BuildContext context,
  required Widget child,

  /// The padding for the content of the panel.
  EdgeInsetsGeometry contentPadding = EdgeInsets.zero,

  /// The title of the panel.
  ///
  /// If `null`, no title will be displayed.
  String? title,

  /// The size of the panel.
  ///
  /// Adjusts automatically based on the screen width.
  EPanelSize size = EPanelSize.small,

  /// Whether the panel should be dismissed by tapping outside of it.
  ///
  /// If `true`, [onClose] will also be called after the panel is dismissed.
  bool barrierDismissible = true,

  /// Enable padding for the top of the panel.
  ///
  /// If `true`, [topPadding] will be used as the padding for the top of the panel.
  bool enableTopPadding = false,

  /// Padding for the top of the panel.
  double topPadding = kToolbarHeight,

  /// Callback to be called shortly before the panel is closed (by clicking on the close button or outside the panel).
  VoidCallback? onClose,
}) async {
  final navigator = Navigator.of(context);

  final previousRoute = _activePanelRoute;
  if (previousRoute != null && previousRoute.navigator != null) {
    previousRoute.navigator!.removeRoute(previousRoute);
  }

  final route = _CasaPanelRoute<T>(
    child: child,
    title: title,
    size: size,
    barrierDismissible: barrierDismissible,
    enableTopPadding: enableTopPadding,
    topPadding: topPadding,
    onClose: onClose,
    contentPadding: contentPadding,
  );

  _activePanelRoute = route;

  final result = await navigator.push(route);

  if (identical(_activePanelRoute, route)) {
    _activePanelRoute = null;
  }

  return result;
}

class _CasaPanelRoute<T> extends PageRoute<T> {
  // region Parameters

  final Widget child;

  final String? title;

  final EPanelSize size;

  final bool _barrierDismissible;

  final bool enableTopPadding;

  final double topPadding;

  final VoidCallback? onClose;

  final EdgeInsetsGeometry contentPadding;
  bool _didNotifyClose = false;

  // endregion

  // region Constructors

  _CasaPanelRoute({
    required this.child,
    this.title,
    bool barrierDismissible = true,
    this.size = EPanelSize.small,
    this.enableTopPadding = false,
    this.topPadding = kToolbarHeight,
    this.onClose,
    this.contentPadding = EdgeInsets.zero,
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

  void _onClose(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _notifyClosed() {
    if (_didNotifyClose) {
      return;
    }

    _didNotifyClose = true;
    onClose?.call();
  }

  @override
  bool didPop(T? result) {
    final didPop = super.didPop(result);
    if (didPop) {
      _notifyClosed();
    }

    if (identical(_activePanelRoute, this)) {
      _activePanelRoute = null;
    }

    return didPop;
  }

  @override
  void didComplete(T? result) {
    _notifyClosed();

    if (identical(_activePanelRoute, this)) {
      _activePanelRoute = null;
    }

    super.didComplete(result);
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
            onPressed: () => _onClose(context),
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
            padding: enableTopPadding
                ? EdgeInsets.only(top: topPadding)
                : EdgeInsets.zero,
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
                      child: Padding(
                        padding: contentPadding,
                        child: child,
                      ),
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
