import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:flutter/material.dart';

class CasaDrawer extends StatefulWidget {
  final Widget? header;

  final List<IMenuItem> items;

  final List<IMenuItem> service;

  const CasaDrawer({
    super.key,
    this.header,
    required this.items,
    this.service = const [],
  });

  @override
  State<CasaDrawer> createState() => _CasaDrawerState();
}

class _CasaDrawerState extends State<CasaDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.header != null) widget.header!,

            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.items.length,
                (index) {
                  final item = widget.items[index];

                  return ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    onTap: () {
                      Navigator.of(context).pop(); // Drawer schließen
                      item.onTap();
                    },
                  );
                },
              ),
            ),

            Spacer(),
            if (widget.service.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.service.length,
                  (index) {
                    final item = widget.service[index];

                    return ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.title),
                      onTap: () {
                        Navigator.of(context).pop(); // Drawer schließen
                        item.onTap();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
