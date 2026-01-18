import 'package:shared/shared.dart';

abstract class RepoSource implements IRepositorySource {
  @override
  final IUser user;

  const RepoSource({required this.user});
}
