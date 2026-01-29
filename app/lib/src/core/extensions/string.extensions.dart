extension StringFormatting on String {
  /// Capitalizes the first letter of a string.
  ///
  /// If the string is empty, an empty string is returned.
  String get asCapitalized {
    if (isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
