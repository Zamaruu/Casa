/// Generic contract for immutable-like copy operations.
abstract interface class ICopyable<C> {
  /// Creates a modified copy of the current object.
  ///
  /// Returns type `C`, usually the same interface type.
  C copyWith();
}
