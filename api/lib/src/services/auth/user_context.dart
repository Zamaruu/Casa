import 'package:shared/shared.dart';

class UserContext {
  final IUser user;

  const UserContext(this.user);

  bool hasGroup(String group) {
    return user.groups.contains(group);
  }

  bool hasAnyGroup(List<String> groups) {
    return groups.any(user.groups.contains);
  }

  bool get isAdmin => hasGroup('admin');
}
