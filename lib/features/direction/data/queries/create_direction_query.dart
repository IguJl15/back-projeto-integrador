import 'package:postgres/postgres.dart';

import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/direction.dart';
import 'get_all_direction_terms_query.dart';
import 'get_direction_query.dart';
import 'insert_direction_terms.dart';

final class CreateDirectionQuery implements TransactionQueryParser<Direction> {
  final String createDirectionQueryString = """
INSERT INTO $directionsTable(title, user_id, direction_email, status_id)
    VALUES (
        @title,
        @userId, 
        @directionEmail, 
        (select status_id from directionstatus where status_description ilike @statusName)
    )
    RETURNING *;
""";

  final String title;
  final String statusName;
  final String userId;
  final String? directionEmail;
  final List<String> inclusionTermsIds;
  final List<String> exclusionTermsIds;

  CreateDirectionQuery({
    required this.title,
    required this.statusName,
    required this.userId,
    required this.directionEmail,
    required this.inclusionTermsIds,
    required this.exclusionTermsIds,
  });

  factory CreateDirectionQuery.fromDirection(Direction direction) => CreateDirectionQuery(
        title: direction.title,
        userId: direction.userId,
        directionEmail: direction.redirectEmail,
        statusName: direction.status.verbose,
        inclusionTermsIds: direction.inclusionTerms.map((e) => e.id).toList(),
        exclusionTermsIds: direction.exclusionTerms.map((e) => e.id).toList(),
      );

  @override
  Future<List<Map<String, Map<String, dynamic>>>> transaction(
    PostgreSQLExecutionContext connection,
  ) async {
    final newDirection = await connection.mappedResultsQuery(
      createDirectionQueryString,
      substitutionValues: {
        'title': title,
        'statusName': statusName,
        'userId': userId,
        'directionEmail': directionEmail,
      },
    );
    final String descriptionId = newDirection.single[directionsTable]?['direction_id'];

    final insertDirectionsTerms = InsertDirectionsTerms(termIds: inclusionTermsIds, directionId: descriptionId);
    await connection.query(
      insertDirectionsTerms.queryString,
      substitutionValues: insertDirectionsTerms.variables,
    );

    if (exclusionTermsIds.isNotEmpty) {
      final insertExcDirectionsTerms = InsertDirectionsTerms(
        termIds: exclusionTermsIds,
        directionId: descriptionId,
        exclusionTerm: true,
      );
      await connection.query(
        insertExcDirectionsTerms.queryString,
        substitutionValues: insertExcDirectionsTerms.variables,
      );
    }

    final termsQuery = GetAllDirectionTermsQuery(descriptionId);
    final terms = await connection.mappedResultsQuery(termsQuery.queryString, substitutionValues: termsQuery.variables);
    newDirection.single[directionsTable]!['inclusionTerms'] = termsQuery.fromDbRowsMaps(
      terms
          .where(
            (termRow) => termRow[directionTermsTable]!['is_exclusion_term'] == false,
          )
          .toList(),
    );
    newDirection.single[directionsTable]!['exclusionTerms'] = termsQuery.fromDbRowsMaps(
      terms
          .where(
            (termRow) => termRow[directionTermsTable]!['is_exclusion_term'],
          )
          .toList(),
    );

    final status = await connection.query(
      "select status_description from directionstatus status where status_id = @statusId",
      substitutionValues: {'statusId': newDirection.single[directionsTable]!['status_id']},
    );
    newDirection.single[directionsTable]!['status_description'] = status.single.first as String;

    return newDirection;
  }

  @override
  Direction fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    return GetDirectionQuery.getDirectionFromDbMap(dbResult.single);
  }
}
