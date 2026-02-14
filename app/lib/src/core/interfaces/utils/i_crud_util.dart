import 'package:casa/src/core/interfaces/utils/i_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

abstract interface class ICrudUtil<T extends IEntity> implements IUtil {
  // region Crud-Methods

  Future<IValueResponse<T>?> create(BuildContext context, WidgetRef ref);

  Future<IValueResponse<T>?> edit(BuildContext context, WidgetRef ref, T entity);

  Future<IResponse> delete(BuildContext context, WidgetRef ref, T entity);

  // endregion
}

abstract interface class ICachedCrudUtil<T extends IEntity> implements ICrudUtil<T> {
  Future<IResponse> refresh(BuildContext context, WidgetRef ref);
}
