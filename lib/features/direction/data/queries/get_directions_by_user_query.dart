import 'package:postgres/postgres.dart';

import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/direction.dart';
import 'get_all_direction_terms_query.dart';
import 'get_direction_query.dart';

class GetDirectionsByUserQuery implements TransactionQueryParser<List<Direction>> {
  final String queryString = """
SELECT
    $directionsTable.*
FROM $directionsTable 
WHERE user_id = @userId
""";

  final String userId;

  GetDirectionsByUserQuery(this.userId);

  @override
  Future<List<Map<String, Map<String, dynamic>>>> transaction(PostgreSQLExecutionContext connection) async {
    final directions = await connection.mappedResultsQuery(queryString, substitutionValues: {'userId': userId});

    for (var direction in directions) {
      final id = direction[directionsTable]!['direction_id'];

      final getTermsQueries = GetAllDirectionTermsQuery(id);
      final terms = await connection.mappedResultsQuery(
        getTermsQueries.queryString,
        substitutionValues: getTermsQueries.variables,
      );
      direction[directionsTable]!['terms'] = getTermsQueries.fromDbRowsMaps(terms);

      final status = await connection.query(
        "select status_description from directionstatus status where status_id = @statusId",
        substitutionValues: {'statusId': direction[directionsTable]!['status_id']},
      );
      direction[directionsTable]!['status_description'] = status.single.first as String;
    }

    return directions;
  }

  @override
  fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {
    return rows
        .map(
          (row) => GetDirectionQuery.getDirectionFromDbMap(row),
        )
        .toList();
  }
}
