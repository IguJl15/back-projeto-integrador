import 'package:postgres/postgres.dart';

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

abstract interface class TransactionQueryParser<T> {
  Future<List<Map<String, Map<String, dynamic>>>> transaction(PostgreSQLExecutionContext connection);

  T fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows);
}
