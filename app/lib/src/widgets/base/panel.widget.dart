import 'package:casa/src/core/extensions/context.extension.dart';
import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/models/layout/layout.dart';
import 'package:casa/src/widgets/base/layoutbuilder.widget.dart';
import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';

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
}) {
  return Navigator.of(context).push(
    _CasaPanelRoute<T>(
      child: child,
      title: title,
      size: size,
      barrierDismissible: barrierDismissible,
      enableTopPadding: enableTopPadding,
      topPadding: topPadding,
      onClose: onClose,
      contentPadding: contentPadding,
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

  final VoidCallback? onClose;

  final EdgeInsetsGeometry contentPadding;

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
    if (onClose != null) {
      onClose!();
    }

    Navigator.of(context).pop();
  }

  @override
  bool didPop(T? result) {
    final didPop = super.didPop(result);
    onClose?.call();

    return didPop;
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
            padding: enableTopPadding ? EdgeInsets.only(top: topPadding) : EdgeInsets.zero,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: Material(
                color: context.theme.colorScheme.surface,
                elevation: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
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
