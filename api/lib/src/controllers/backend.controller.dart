import 'dart:convert';

import 'package:casa_api/src/abstract/controller/api.controller.dart';
import 'package:casa_api/src/models/responses/api.response.dart';
import 'package:casa_api/src/services/auth/apikey.service.dart';
import 'package:casa_api/src/services/service_locator.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class BackendController extends ApiController {
  final ApiKeyService apikeyService;

  final IApiKeyOperations apiKeyOperations;

  BackendController({
    required this.apiKeyOperations,
    this.apikeyService = const ApiKeyService(),
  });

  factory BackendController.endpoint() {
    final apiKeyOperations = services.database.get<IApiKeyOperations>();

    final controller = BackendController(apiKeyOperations: apiKeyOperations);
    controller.registerEndpoints();
    return controller;
  }

  @override
  String get path => "meta";

  @override
  void registerEndpoints() {
    //router.get('/apikeys', getApiKeys);
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

      final saveResponse = await apiKeyOperations.save(apiKey);

      if (saveResponse.isSuccess && saveResponse.hasValue) {
        final savedKey = saveResponse.value!;

        final json = {
          "rawKey": rawKey,
          "keyInfos": savedKey.toJson(),
        };

        return ApiResponse.created(jsonEncode(json));
      } else {
        return ApiResponse.internalServerError(saveResponse.message ?? "Error while saving apikey");
      }
    });
  }
}
