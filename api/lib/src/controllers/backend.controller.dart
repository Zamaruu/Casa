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
    required super.logger,
    required this.apiKeyOperations,
    required this.apikeyService,
  });

  factory BackendController.endpoint() {
    final logger = services.logger;
    final apiKeyOperations = services.database.get<IApiKeyOperations>();
    final apikeyService = services.get<IApiKeyAuthenticator>();

    final controller = BackendController(
      logger: logger,
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
    router.delete('/apikeys/<id>', deleteApiKey);
  }

  Future<ApiResponse> createApiKey(Request request) async {
    return runCustomGuarded(() async {
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
    }, onError: onGuardedError);
  }

  Future<ApiResponse> getApiKeys(Request request) async {
    return runCustomGuarded(() async {
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
    }, onError: onGuardedError);
  }

  /// Reads id form query and deletes the corresponding entity.
  Future<ApiResponse> deleteApiKey(Request request, String id) async {
    return runCustomGuarded(() async {
      final entityResponse = await apiKeyOperations.find(id);

      if (entityResponse.isError || entityResponse.hasValue == false) {
        return ApiResponse.notFound("Entity not found");
      }

      final entity = entityResponse.value!;
      final deleteResponse = await apiKeyOperations.delete(entity);

      if (deleteResponse.isSuccess) {
        final result = encodeResult(message: "Entity with id $id deleted");

        return ApiResponse.ok(result);
      } else {
        final error = encodeError(
          message: deleteResponse.message ?? "Error while deleting apikey",
          error: deleteResponse.error,
          stackTrace: deleteResponse.stackTrace,
        );

        return ApiResponse.internalServerError(error);
      }
    }, onError: onGuardedError);
  }
}
