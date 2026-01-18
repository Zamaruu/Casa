import 'package:shared/shared.dart';

abstract interface class IRepositorySource {
  /// The currently authenticated user of the application to give every operation a user context.
  IUser get user;
}
