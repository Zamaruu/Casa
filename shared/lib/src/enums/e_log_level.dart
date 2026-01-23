enum ELogLevel {
  debug,
  info,
  warn,
  error
  ;

  static ELogLevel getByName(String? name) {
    return ELogLevel.values.firstWhere((element) => element.name == name, orElse: () => ELogLevel.info);
  }
}
