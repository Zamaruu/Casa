import 'dart:io';

import 'package:api/src/config/config_loader.dart';
import 'package:api/src/controllers/controller_builder.dart';
import 'package:api/src/services/service.initializer.dart';
import 'package:api/src/utils/logger.util.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final config = ConfigLoader.load();

  final serviceStartUpResponse = await ServiceInitializer.startUpServices(config);

  if (serviceStartUpResponse.isError) {
    apiLog(
      message: 'Error while starting up services.',
      error: serviceStartUpResponse.error,
      stackTrace: serviceStartUpResponse.stackTrace,
    );

    return;
  }

  // Configure a pipeline that logs requests.
  final endpoints = ControllerBuilder.buildEndpoints();
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(endpoints);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
