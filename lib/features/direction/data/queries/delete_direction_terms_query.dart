import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class DeleteDirectionsTermsQuery implements QueryParser<void> {
  @override
  final String queryString = """
DELETE FROM $directionsTable
WHERE direction_id = @directionId
    AND term_id IN unnest(@terms::uuid[]);
""";

  @override
  final Map<String, dynamic> variables;

  DeleteDirectionsTermsQuery({
    required String directionId,
    required List<String> termIds,
  }) : variables = {
          'directionId': directionId,
          'terms': termIds,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {}
}
