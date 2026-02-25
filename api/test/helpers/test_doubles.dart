import 'package:casa_api/src/config/database_config.dart';
import 'package:casa_api/src/interfaces/auth/i_api_key_authenticator.dart';
import 'package:casa_api/src/interfaces/auth/i_user_authenticator.dart';
import 'package:casa_api/src/interfaces/i_api_config.dart';
import 'package:shared/shared.dart';
import 'package:shared/src/enums/e_feature.dart';

class TestLogger implements ILogger<IErrorLog> {
  @override
  final ELogLevel level;

  int logCalls = 0;
  IErrorLog? last;

  TestLogger({this.level = ELogLevel.misc});

  @override
  Future<void> log(IErrorLog logEntry) async {
    logCalls += 1;
    last = logEntry;
  }
}

class TestUserAuthenticator implements IUserAuthenticator {
  IUser? authenticateResult;
  String tokenToGenerate;

  TestUserAuthenticator({
    this.authenticateResult,
    this.tokenToGenerate = 'token',
  });

  @override
  Future<IUser?> authenticate(String jwt) async => authenticateResult;

  @override
  String generate(IUser user) => tokenToGenerate;
}

class TestApiKeyAuthenticator implements IApiKeyAuthenticator {
  IApiKey? authenticateResult;
  String rawKey;
  String hash;

  TestApiKeyAuthenticator({
    this.authenticateResult,
    this.rawKey = 'casa_live_test',
    this.hash = 'hash',
  });

  @override
  Future<IApiKey?> authenticate(String rawKey) async => authenticateResult;

  @override
  String generateRawApiKey() => rawKey;

  @override
  String hashApiKey(String rawKey) => hash;
}

class TestUserOperations implements IUserOperations {
  IValueResponse<IUser?> findByEmailResponse =
      const ValueResponse<IUser?>.failure(message: 'not configured');

  @override
  Future<IValueResponse<IUser?>> findByEmail(String email) async =>
      findByEmailResponse;

  @override
  Future<IResponse> delete(IUser entity) async => const Response.success();

  @override
  Future<IValueResponse<IUser>> find(String id) async =>
      ValueResponse.success(value: User.initial());

  @override
  Future<IValueResponse<List<IUser>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<IUser>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<IUser>> save(IUser entity) async =>
      ValueResponse.success(value: entity);

  @override
  Future<IValueResponse<List<IUser>>> saveMany(List<IUser> entities) async =>
      ValueResponse.success(value: entities);
}

class TestApiKeyOperations implements IApiKeyOperations {
  IValueResponse<IApiKey> findByHashResponse =
      const ValueResponse<IApiKey>.failure(message: 'not configured');
  IValueResponse<List<IApiKey>> findAllResponse = const ValueResponse.success(
    value: [],
  );
  IValueResponse<IApiKey> saveResponse = ValueResponse.success(
    value: const ApiKey(id: 'k1', name: 'name', keyHash: 'hash'),
  );
  IValueResponse<IApiKey> findResponse = ValueResponse.success(
    value: const ApiKey(id: 'k1', name: 'name', keyHash: 'hash'),
  );
  IResponse deleteResponse = const Response.success();
  int updateLastUsedCalls = 0;

  @override
  Future<IValueResponse<IApiKey>> findByHash(String hash) async =>
      findByHashResponse;

  @override
  Future<IResponse> updateLastUsed(String id) async {
    updateLastUsedCalls += 1;
    return const Response.success();
  }

  @override
  Future<IResponse> delete(IApiKey entity) async => deleteResponse;

  @override
  Future<IValueResponse<IApiKey>> find(String id) async => findResponse;

  @override
  Future<IValueResponse<List<IApiKey>>> findAll() async => findAllResponse;

  @override
  Future<IValueResponse<List<IApiKey>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<IApiKey>> save(IApiKey entity) async => saveResponse;

  @override
  Future<IValueResponse<List<IApiKey>>> saveMany(
    List<IApiKey> entities,
  ) async => ValueResponse.success(value: entities);
}

class TestErrorLogOperations implements IErrorLogOperations {
  int saveCalls = 0;

  @override
  Future<IValueResponse<IErrorLog>> save(IErrorLog entity) async {
    saveCalls += 1;
    return ValueResponse.success(value: entity);
  }

  @override
  Future<IResponse> delete(IErrorLog entity) async => const Response.success();

  @override
  Future<IValueResponse<IErrorLog>> find(String id) async =>
      ValueResponse.failure(message: 'not found');

  @override
  Future<IValueResponse<List<IErrorLog>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<IErrorLog>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<IErrorLog>>> saveMany(
    List<IErrorLog> entities,
  ) async => ValueResponse.success(value: entities);
}

class TestTodoItemOperations implements ITodoItemOperations {
  IValueResponse<List<ITodo>> byListResponse = const ValueResponse.success(
    value: [],
  );

  @override
  Future<IValueResponse<List<ITodo>>> findByListId(String listId) async =>
      byListResponse;

  @override
  Future<IResponse> deleteByListId(String listId) async =>
      const Response.success();

  @override
  Future<IResponse> detachFromListId(String listId) async =>
      const Response.success();

  @override
  Future<IResponse> delete(ITodo entity) async => const Response.success();

  @override
  Future<IValueResponse<ITodo>> find(String id) async =>
      ValueResponse.failure(message: 'not found');

  @override
  Future<IValueResponse<List<ITodo>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodo>>> findMany(List<String> ids) async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<ITodo>> save(ITodo entity) async =>
      ValueResponse.success(value: entity);

  @override
  Future<IValueResponse<List<ITodo>>> saveMany(List<ITodo> entities) async =>
      ValueResponse.success(value: entities);
}

class TestTodoAttachmentOperations implements ITodoAttachmentOperations {
  IValueResponse<List<ITodoAttachment>> byItemResponse =
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodoAttachment>>> findByTodoItemId(
    String todoItemId,
  ) async => byItemResponse;

  @override
  Future<IResponse> delete(ITodoAttachment entity) async =>
      const Response.success();

  @override
  Future<IValueResponse<ITodoAttachment>> find(String id) async =>
      ValueResponse.failure(message: 'not found');

  @override
  Future<IValueResponse<List<ITodoAttachment>>> findAll() async =>
      const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<List<ITodoAttachment>>> findMany(
    List<String> ids,
  ) async => const ValueResponse.success(value: []);

  @override
  Future<IValueResponse<ITodoAttachment>> save(ITodoAttachment entity) async =>
      ValueResponse.success(value: entity);

  @override
  Future<IValueResponse<List<ITodoAttachment>>> saveMany(
    List<ITodoAttachment> entities,
  ) async => ValueResponse.success(value: entities);
}

class TestApiConfig implements IApiConfig {
  @override
  final bool enableOpenApi;

  @override
  final ELogLevel logLevel;

  @override
  final IDatabaseConfig databaseConfig;

  @override
  final Map<String, String> rawConfigs;

  const TestApiConfig({
    this.enableOpenApi = true,
    this.logLevel = ELogLevel.info,
    this.databaseConfig = const DatabaseConfig(
      connectionString: 'mongodb://localhost',
      databaseType: EDatabase.mongodb,
    ),
    this.rawConfigs = const {},
  });
}

ErrorLog testErrorLog({ELogLevel level = ELogLevel.error}) {
  return ErrorLog(
    id: 'err-1',
    title: 'err',
    message: 'msg',
    logLevel: level,
    exceptionType: 'Exception',
    stackTrace: StackTrace.current,
    feature: EFeature.api,
  );
}
