import 'package:shared/shared.dart';

abstract class RepoSource {
  final IUser user;

  const RepoSource({required this.user});
}
