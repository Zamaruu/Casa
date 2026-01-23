enum EDatabase {
  mongodb,
  mariadb,
  sqlite
  ;

  static EDatabase getByName(String? name) {
    return EDatabase.values.firstWhere((element) => element.name == name, orElse: () => EDatabase.mongodb);
  }
}
