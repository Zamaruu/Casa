import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract interface class IRoutableWidget<T extends IEntity> {
  void openItemNavigate(BuildContext context, WidgetRef ref, T? item);
}
