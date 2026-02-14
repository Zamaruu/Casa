import 'package:casa/src/core/models/enums/e_panel_size.dart';
import 'package:casa/src/core/models/layout/layout.dart';
import 'package:casa/src/widgets/base/layoutbuilder.widget.dart';
import 'package:flutter/material.dart';

class PanelController {
  OverlayEntry? _entry;

  PanelController();

  bool get isOpen => _entry != null;

  // region Methods

  void show(
    BuildContext context, {
    String? title,
    EPanelSize size = EPanelSize.small,
    required Widget child,
  }) {
    if (_entry != null) return;

    final overlay = Overlay.of(context);

    _entry = OverlayEntry(
      builder: (context) => _CasaPanel(
        title: title,
        onClose: hide,
        child: child,
      ),
    );

    overlay.insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }

  void dispose() {
    _entry?.remove();
  }

  // endregion
}

class _CasaPanel extends StatefulWidget {
  final Widget child;

  final String? title;

  final EPanelSize size;

  final VoidCallback onClose;

  const _CasaPanel({
    required this.child,
    required this.onClose,
    this.title,
    // ignore: unused_element_parameter
    this.size = EPanelSize.small,
  });

  @override
  State<_CasaPanel> createState() => _CasaPanelState();
}

class _CasaPanelState extends State<_CasaPanel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  // region Lifecycle

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // endregion

  // region Methods

  void _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  double _calculateWidth(Layout layout) {
    switch (widget.size) {
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
            child: Text(
              widget.title ?? 'Hilfe',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _close,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withValues(alpha: 0.3),
      child: CasaLayoutBuilder(
        builder: (context, layout) {
          final panelWidth = _calculateWidth(layout);

          return Stack(
            children: [
              /// Scrim
              Positioned.fill(
                child: GestureDetector(
                  onTap: _close,
                  child: Container(color: Colors.transparent),
                ),
              ),

              /// Panel
              Align(
                alignment: Alignment.centerRight,
                child: SlideTransition(
                  position: _animation,
                  child: Container(
                    width: panelWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
