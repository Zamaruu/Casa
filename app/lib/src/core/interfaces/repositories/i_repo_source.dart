import 'package:casa/src/core/interfaces/api/i_typed_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract interface class IRepoSource implements IRepositorySource {
  Ref get ref;
}

abstract interface class IAuthenticatedRepoSource implements IRepoSource {
  /// The currently authenticated user of the application to give every operation a user context.
  IUser get user;
}

abstract interface class ITypedRepoSource<T extends IEntity> implements IAuthenticatedRepoSource {
  ITypedApi<T> get api;
}
