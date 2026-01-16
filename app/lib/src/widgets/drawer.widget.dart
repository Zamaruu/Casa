import 'package:casa/src/app/interfaces/i_menu_item.dart';
import 'package:flutter/material.dart';

class CasaDrawer extends StatefulWidget {
  final Widget? header;

  final List<IMenuItem> items;

  const CasaDrawer({
    super.key,
    this.header,
    required this.items,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.header != null) widget.header!,

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
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
          ],
        ),
      ),
    );
  }
}
