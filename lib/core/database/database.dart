import 'package:postgres/postgres.dart';

import '../env/env.dart';
import 'query_parser.dart';

class DatabaseConnection {
  final String database = Env().databaseName;
  final String host = Env().databaseHost;
  final int port = Env().databasePort;
  final String user = Env().databaseUser;
  final String password = Env().databasePassword;

  PostgreSQLConnection? postgresConnection;

  static DatabaseConnection? _instance;
  static DatabaseConnection get instance => _instance ??= DatabaseConnection._();

  DatabaseConnection._();

  Future<void> openConnection() async {
    if (postgresConnection != null && !postgresConnection!.isClosed) return;

    postgresConnection = PostgreSQLConnection(
      host,
      port,
      database,
      username: user,
      password: password,
      allowClearTextPassword: true,
    );

    postgresConnection!.open().then(
      (value) {
        print("CONECTADO AO BANCO DE DADOS POSTGRES");
      },
      onError: (error, stackTrace) => print(error),
    );
  }

  Future<void> closeConnection() async {
    if (postgresConnection == null || postgresConnection!.isClosed) return;

    await postgresConnection!.close();
  }

  Future<T> query<T>(QueryParser<T> query) async {
    final rows = await postgresConnection!.mappedResultsQuery(query.queryString, substitutionValues: query.variables);
    return query.fromDbRowsMaps(rows);
  }
}
