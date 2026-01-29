import 'package:shared/shared.dart';

abstract class ApiRepoSource implements IRepositorySource {
  final IUser user;

  const ApiRepoSource({required this.user});
}
