import 'dart:convert';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/interfaces/auth/i_api_key_authenticator.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class BackendController extends ApiController {
  final IApiKeyAuthenticator apikeyService;

  final IApiKeyOperations apiKeyOperations;

  BackendController({
    required this.apiKeyOperations,
    required this.apikeyService,
  });

  factory BackendController.endpoint() {
    final apiKeyOperations = services.database.get<IApiKeyOperations>();
    final apikeyService = services.get<IApiKeyAuthenticator>();

    final controller = BackendController(
      apiKeyOperations: apiKeyOperations,
      apikeyService: apikeyService,
    );

    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "backend";

  @override
  void registerEndpoints() {
    router.get('/apikeys', getApiKeys);
    router.post('/apikeys', createApiKey);
    // router.delete('/apikeys', deleteApiKey);
  }

  Future<ApiResponse> createApiKey(Request request) async {
    return runGuarded(() async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final entity = ApiKey.fromJson(data);

      final rawKey = apikeyService.generateRawApiKey();
      final hash = apikeyService.hashApiKey(rawKey);

      final apiKey = entity.copyWith(keyHash: hash);

      final response = await apiKeyOperations.save(apiKey);

      if (response.isSuccess && response.hasValue) {
        final savedKey = response.value!;

        final json = {
          "rawKey": rawKey,
          "keyInfos": savedKey.toJson(),
        };

        return ApiResponse.created(jsonEncode(json));
      } else {
        final error = encodeError(
          message: response.message ?? "Error while saving apikey",
          error: response.error,
          stackTrace: response.stackTrace,
        );
        return ApiResponse.internalServerError(error);
      }
    });
  }

  Future<ApiResponse> getApiKeys(Request request) async {
    return runGuarded(() async {
      final response = await apiKeyOperations.findAll();

      if (response.isSuccess && response.hasValue) {
        final entities = response.value!;
        final json = entities.map((e) => e.toJson()).toList();

        return ApiResponse.ok(jsonEncode(json));
      } else {
        final error = encodeError(
          message: response.message ?? "Error while getting apikeys",
          error: response.error,
          stackTrace: response.stackTrace,
        );
        return ApiResponse.internalServerError(error);
      }
    });
  }
}
