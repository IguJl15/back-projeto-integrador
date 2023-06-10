abstract interface class QueryParser<T> {
  String get queryString;
  Map<String, dynamic> get variables;

  QueryParser() {
    assert(
      variables.keys.every((element) => !element.startsWith("@")),
      "Variables should not start with '@' since it is the symbol that represent the variable in the SQL query",
    );
  }

  T fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows);
}
