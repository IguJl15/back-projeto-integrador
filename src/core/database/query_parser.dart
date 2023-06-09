abstract class QueryParser<T> {
  final String queryString;
  final Map<String, dynamic> variables;

  QueryParser({
    required this.queryString,
    required this.variables,
  }) : assert(
          variables.keys.every((element) => !element.startsWith("@")),
          "Variables should not start with '@' since it is the symbol that represent the variable in the SQL query",
        );

  T fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows);
}
