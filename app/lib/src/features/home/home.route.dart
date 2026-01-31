import 'package:casa/src/features/infos/data/repositories/info.repository.dart';
import 'package:casa/src/widgets/scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class HomeRoute extends ConsumerWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CasaScaffold<IValueResponse<IServerVersionInfo>>.future(
      title: "Home",
      future: ref.read(infoRepositoryProvider).getServerVersionInfo(forceRefresh: true),
      futureBuilder: (context, ref, response) {
        if (response.isError || response.hasValue == false) {
          return Center(child: Text('Error: ${response.message}'));
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Server Version: ${response.value!.version}'),
              Text('Server OS: ${response.value!.platform}'),
            ],
          ),
        );
      },
    );
  }
}
