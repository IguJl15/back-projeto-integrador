import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class DeleteDirectionQuery implements QueryParser<void> {
  @override
  final String queryString = """
WITH t AS (
    DELETE FROM $directionTermsTable
    WHERE direction_id = @directionId
)
DELETE FROM $directionsTable
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
