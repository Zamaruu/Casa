enum EApiController {
  unknown(""),
  auth("auth"),
  user("user"),
  meta("meta")
  ;

  final String path;

  const EApiController(this.path);

  String get endpoint => "/$path";

  static EApiController fromString(String value) {
    final controller = values.firstWhere((element) => element.path == value, orElse: () => unknown);
    return controller;
  }
}
