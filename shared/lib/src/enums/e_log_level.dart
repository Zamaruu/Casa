enum ELogLevel {
  misc(0),
  debug(1),
  info(2),
  warn(3),
  error(4)
  ;

  final int severity;

  const ELogLevel(this.severity);

  static ELogLevel getByName(String? name) {
    return ELogLevel.values.firstWhere((element) => element.name == name, orElse: () => ELogLevel.info);
  }

  static ELogLevel getFromSeverity(int severity) {
    return ELogLevel.values.firstWhere((element) => element.severity == severity, orElse: () => ELogLevel.info);
  }
}
