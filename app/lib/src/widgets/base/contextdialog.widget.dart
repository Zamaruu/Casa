import 'package:casa/src/widgets/base/text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';

class ContextDialog extends ConsumerWidget {
  // region Parameters

  final IconData? icon;

  final String title;

  final String? subtitle;

  final Widget? content;

  final bool fullScreen;

  final Widget Function(BuildContext context, WidgetRef ref)? builder;

  /// Callback to be called shortly before the dialog is closed.
  final void Function(WidgetRef ref)? onClose;

  // endregion

  // region Constructors

  const ContextDialog({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.onClose,
    this.fullScreen = false,
    required this.content,
  }) : builder = null;

  const ContextDialog.builder({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.fullScreen = false,
    required this.builder,
  }) : content = null,
       onClose = null;

  static Future<T?> openDialog<T>(
    BuildContext context,
    ContextDialog dialog, {
    bool fullScreen = false,
  }) {
    if (fullScreen) {
      return showDialog(
        context: context,
        fullscreenDialog: fullScreen,
        builder: (context) {
          return dialog;
        },
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) {
          return dialog;
        },
      );
    }
  }

  // endregion

  // region Methods

  void _onClose(BuildContext context, WidgetRef ref) {
    if (onClose != null) {
      onClose!(ref);
    }

    Navigator.of(context).pop();
  }

  // endregion

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: icon != null ? Icon(icon) : null,
      constraints: UniversalPlatform.isWeb
          ? BoxConstraints(
              minWidth: 350,
            )
          : null,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CasaText(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (subtitle != null) CasaText(subtitle!),
            ],
          ),
          IconButton(
            onPressed: () => _onClose(context, ref),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: content ?? builder!(context, ref),
    );
  }
}
