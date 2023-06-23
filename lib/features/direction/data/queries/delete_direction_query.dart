import '../../../../core/database/query_parser.dart';

final class DeleteDirectionQuery implements QueryParser<void> {
  static const _tableName = "direction";
  static const dirTermsTable = "DirectionTerms";

  @override
  final String queryString = """
WITH t AS (
    DELETE FROM $dirTermsTable
    WHERE direction_id = @directionId
)
DELETE FROM $_tableName
WHERE direction_id = @directionId;
""";

  @override
  final Map<String, dynamic> variables;

  DeleteDirectionQuery(String directionId)
      : variables = {
          'directionId': directionId,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {}
}
