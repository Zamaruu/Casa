extension ListQueryExtensions<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    return where(test).firstOrNull;
  }
}
