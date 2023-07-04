import 'package:postgres/postgres.dart';

import '../../../../core/database/query_parser.dart';
import '../../../term/domain/models/term.dart';
import '../../domain/models/direction.dart';
import 'delete_direction_terms_query.dart';
import 'get_direction_query.dart';
import 'insert_direction_terms.dart';

class UpdateDirectionQuery implements TransactionQueryParser<Direction> {
  final String directionId;

  final String? newTitle;
  final String? newRedirectEmail;
  final String? newStatus;
  final List<Term> removedInclusionTerms;
  final List<Term> addedInclusionTerms;

  final List<Term> removedExclusionTerms;
  final List<Term> addedExclusionTerms;

  UpdateDirectionQuery({
    required this.directionId,
    required this.newTitle,
    required this.newRedirectEmail,
    required DirectionStatus? newStatus,
    required this.removedInclusionTerms,
    required this.addedInclusionTerms,
    required this.removedExclusionTerms,
    required this.addedExclusionTerms,
  })  : assert(addedInclusionTerms.every((t) => t.id.isNotEmpty)),
        assert(removedInclusionTerms.every((t) => t.id.isNotEmpty)),
        assert(addedExclusionTerms.every((t) => t.id.isNotEmpty)),
        assert(removedExclusionTerms.every((t) => t.id.isNotEmpty)),
        newStatus = newStatus?.verbose;

  @override
  Future<List<Map<String, Map<String, dynamic>>>> transaction(PostgreSQLExecutionContext connection) async {
    final removedTerms = [...removedInclusionTerms, ...removedExclusionTerms];
    if (removedTerms.isNotEmpty) {
      final deleteTermsQuery = DeleteDirectionsTermsQuery(
        directionId: directionId,
        termIds: removedTerms.map((e) => e.id).toList(),
      );
      await connection.execute(
        deleteTermsQuery.queryString,
        substitutionValues: deleteTermsQuery.variables,
      );
    }
    if (addedInclusionTerms.isNotEmpty) {
      final insertDirectionsTerms = InsertDirectionsTerms(
        directionId: directionId,
        termIds: addedInclusionTerms.map((e) => e.id).toList(),
      );
      await connection.execute(
        insertDirectionsTerms.queryString,
        substitutionValues: insertDirectionsTerms.variables,
      );
    }
    if (addedExclusionTerms.isNotEmpty) {
      final insertDirectionsTerms = InsertDirectionsTerms(
        directionId: directionId,
        termIds: addedExclusionTerms.map((e) => e.id).toList(),
        exclusionTerm: true,
      );
      await connection.execute(
        insertDirectionsTerms.queryString,
        substitutionValues: insertDirectionsTerms.variables,
      );
    }

    final updatesStatements = <String>[];

    if (newTitle != null && newTitle!.isNotEmpty) updatesStatements.add('title = @title');
    if (newRedirectEmail != null) updatesStatements.add('direction_email = @redirectEmail');
    if (newStatus != null) {
      updatesStatements.add('status_id = (select status_id from directionstatus where status_description = @status)');
    }

    if (updatesStatements.isNotEmpty) {
      final updatesStatementsString = updatesStatements.join(', ');
      final query = '''
        UPDATE direction 
        SET $updatesStatementsString
        RETURNING *;
      '''
          .trim();

      await connection.execute(
        query,
        substitutionValues: {
          'title': newTitle ?? '',
          'redirectEmail': newRedirectEmail ?? '',
          'status': newStatus ?? '',
        },
      );
    }

    return await GetDirectionQuery(directionId).transaction(connection);
  }

  @override
  fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {
    return GetDirectionQuery.getDirectionFromDbMap(rows.single);
  }
}
