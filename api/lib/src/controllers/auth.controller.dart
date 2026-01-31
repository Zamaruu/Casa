import 'dart:convert';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

import '../services/service_locator.dart';

class AuthController extends ApiController {
  final IAuthService authService;

  AuthController({
    required this.authService,
  });

  factory AuthController.endpoint() {
    final authService = services.get<IAuthService>();
    final controller = AuthController(authService: authService);
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "auth";

  @override
  void registerEndpoints() {
    router.post("/login", login);
  }

  Future<ApiResponse> login(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final email = data['email'];
      final password = data['password'];

      if (email == null || password == null) {
        return ApiResponse.badRequest('Email and password required');
      }

      final tokenResponse = await authService.authenticate(
        email,
        password,
      );

      if (tokenResponse.isError) {
        final responseJson = jsonEncode(tokenResponse.toJson());
        return ApiResponse.unauthorized(responseJson);
      } else {
        if (tokenResponse.hasValue == false) {
          final responseJson = jsonEncode(tokenResponse.toJson());
          return ApiResponse.internalServerError(responseJson);
        } else {
          final token = tokenResponse.value!;
          return ApiResponse.ok(
            jsonEncode({'accessToken': token}),
          );
        }
      }
    });
  }
}
