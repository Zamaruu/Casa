import 'package:casa/src/core/services/service_initializer.dart';
import 'package:casa/src/core/utils/rendering.util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class RootRoute extends StatefulWidget {
  const RootRoute({super.key});

  @override
  State<RootRoute> createState() => _RootRouteState();
}

class _RootRouteState extends State<RootRoute> {
  late Future<IResponse> initializerFuture;

  @override
  void initState() {
    super.initState();
    initializerFuture = ServiceInitializer.startUpServices();
  }

  // region Methods

  Future<void> handleNavigate() async {
    addFirstFrameCallback(() async {
      navigateToAuth();
    });
  }

  void navigateToAuth() {
    context.replace('/auth');
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<IResponse>(
        future: initializerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            if (snapshot.data!.isSuccess) {
              handleNavigate();
            }
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
