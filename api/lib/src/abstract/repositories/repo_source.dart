import 'package:shared/shared.dart';

abstract class ApiRepoSource implements IRepositorySource {
  @override
  final IUser user;

  const ApiRepoSource({required this.user});
}
