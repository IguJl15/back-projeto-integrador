import 'get_all_direction_terms_query.dart';
import 'package:postgres/postgres.dart';

import '../../../../core/database/query_parser.dart';
import '../../../auth/domain/errors/errors.dart';
import '../../domain/models/direction.dart';
import 'insert_direction_terms.dart';

final class CreateDirectionQuery implements TransactionQueryParser<Direction> {
  static const _tableName = "direction";

  final String createDirectionQueryString = """
INSERT INTO $_tableName(title, user_id, direction_email, status_id)
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
  final List<String> termsIds;

  CreateDirectionQuery({
    required this.title,
    required this.statusName,
    required this.userId,
    required this.directionEmail,
    required this.termsIds,
  });

  factory CreateDirectionQuery.fromDirection(Direction direction) => CreateDirectionQuery(
        title: direction.title,
        userId: direction.userId,
        directionEmail: direction.redirectEmail,
        statusName: direction.status.verbose,
        termsIds: direction.terms.map((e) => e.id).toList(),
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
    final String descriptionId = newDirection.single[_tableName]?['direction_id'];

    final insertDirectionsTerms = InsertDirectionsTerms(termIds: termsIds, directionId: descriptionId);
    await connection.query(
      insertDirectionsTerms.queryString,
      substitutionValues: insertDirectionsTerms.variables,
    );

    final termsQuery = GetAllDirectionTermsQuery(descriptionId);
    final terms = await connection.mappedResultsQuery(termsQuery.queryString, substitutionValues: termsQuery.variables);
    newDirection.single[_tableName]!['terms'] = termsQuery.fromDbRowsMaps(terms);

    final status = await connection.query(
      "select status_description from directionstatus status where status_id = @statusId",
      substitutionValues: {'statusId': newDirection.single[_tableName]!['status_id']},
    );
    newDirection.single[_tableName]!['status_description'] = status.single.first as String;

    return newDirection;
  }

  @override
  Direction fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    final uniqueRow = dbResult.single;

    return Direction(
      id: uniqueRow[_tableName]?['direction_id'],
      title: uniqueRow[_tableName]?['title'],
      redirectEmail: uniqueRow[_tableName]?['direction_email'],
      terms: uniqueRow[_tableName]?['terms'],
      userId: uniqueRow[_tableName]?['user_id'],
      status: DirectionStatus.parse(uniqueRow[_tableName]?['status_description']),
      createdAt: uniqueRow[_tableName]?['created_at'],
      updatedAt: uniqueRow[_tableName]?['updated_at'],
      deletedAt: uniqueRow[_tableName]?['deleted_at'],
    );
  }
}
