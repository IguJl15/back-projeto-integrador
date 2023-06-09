import 'package:postgres/postgres.dart';

import 'query_parser.dart';

class DatabaseConnection {
  static const String database = "proj_integrador_dev";
  static const String host = "localhost";
  static const int port = 5432;
  static const String user = "postgres";
  static const String password = "postgres";

  final postgresConnection = PostgreSQLConnection(
    host,
    port,
    database,
    username: user,
    password: password,
    allowClearTextPassword: true,
  );

  static final instance = DatabaseConnection._();

  DatabaseConnection._();

  Future<void> openConnection() async {
    if (!postgresConnection.isClosed) return;

    postgresConnection.open().then(
      (value) {
        print("CONECTADO AO BANCO DE DADOS POSTGRES");
      },
      onError: (error, stackTrace) => print(error),
    );
  }

  Future<void> closeConnection() async {
    if (postgresConnection.isClosed) return;

    await postgresConnection.close();
  }

  Future<T> query<T>(QueryParser<T> query) async {
    final rows = await postgresConnection.mappedResultsQuery(query.queryString, substitutionValues: query.variables);
    return query.fromDbRowsMaps(rows);
  }
}
