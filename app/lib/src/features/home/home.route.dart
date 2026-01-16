import 'package:casa/src/widgets/scaffold.widget.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CasaScaffold(
      title: "Home",
      builder: (context, ref) {
        return const Center(
          child: Text("Home"),
        );
      },
    );
  }
}
