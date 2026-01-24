import 'dart:convert';

import 'package:api/src/abstract/controller/api.controller.dart';
import 'package:api/src/models/responses/api.response.dart';
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
        return ApiResponse.forbidden(tokenResponse.message ?? "Invalid credentials");
      } else {
        if (tokenResponse.hasValue == false) {
          return ApiResponse.internalServerError('Token could not be generated');
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
