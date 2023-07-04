import 'package:postgres/postgres.dart';

import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/direction.dart';
import 'get_all_direction_terms_query.dart';

class GetDirectionQuery implements TransactionQueryParser<Direction?> {
  final String queryString = """
SELECT
    $directionsTable.*
FROM $directionsTable
WHERE direction_id = @directionId
""";

  final String directionId;

  GetDirectionQuery(this.directionId);

  @override
  Future<List<Map<String, Map<String, dynamic>>>> transaction(PostgreSQLExecutionContext connection) async {
    final directions = await connection.mappedResultsQuery(
      queryString,
      substitutionValues: {'directionId': directionId},
    );
    if (directions.isEmpty) return directions;

    final direction = directions.single;

    final id = direction[directionsTable]!['direction_id'];

    final getTermsQueries = GetAllDirectionTermsQuery(id);
    final terms = await connection.mappedResultsQuery(
      getTermsQueries.queryString,
      substitutionValues: getTermsQueries.variables,
    );
    direction[directionsTable]!['inclusionTerms'] = getTermsQueries.fromDbRowsMaps(
      terms
          .where(
            (termRow) => termRow[directionTermsTable]!['is_exclusion_term'] == false,
          )
          .toList(),
    );
    direction[directionsTable]!['exclusionTerms'] = getTermsQueries.fromDbRowsMaps(
      terms
          .where(
            (termRow) => termRow[directionTermsTable]!['is_exclusion_term'],
          )
          .toList(),
    );
    final status = await connection.query(
      "select status_description from directionstatus status where status_id = @statusId",
      substitutionValues: {'statusId': direction[directionsTable]!['status_id']},
    );
    direction[directionsTable]!['status_description'] = status.single.first as String;

    return directions;
  }

  @override
  fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {
    final row = rows.singleOrNull;
    if (row == null) return null;

    return getDirectionFromDbMap(row);
  }

  static Direction getDirectionFromDbMap(Map<String, Map<String, dynamic>> row, [String tableName = directionsTable]) {
    return Direction(
      id: row[tableName]?['direction_id'],
      title: row[tableName]?['title'],
      redirectEmail: row[tableName]?['redirect_email'] ?? '',
      inclusionTerms: row[tableName]?['inclusionTerms'],
      exclusionTerms: row[tableName]?['exclusionTerms'],
      userId: row[tableName]?['user_id'],
      status: DirectionStatus.parse(row[tableName]?['status_description']),
      createdAt: row[tableName]?['created_at'],
      updatedAt: row[tableName]?['updated_at'],
      deletedAt: row[tableName]?['deleted_at'],
    );
  }
}
