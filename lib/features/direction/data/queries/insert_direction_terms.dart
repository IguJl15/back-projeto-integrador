import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class InsertDirectionsTerms implements QueryParser<void> {
  @override
  final String queryString = """
INSERT INTO $directionTermsTable(term_id, direction_id)
        SELECT
            l.element,
            @directionId
        FROM
            unnest(@terms::uuid[]) as l(element);
""";
  @override
  final Map<String, dynamic> variables;

  InsertDirectionsTerms({
    required List<String> termIds,
    required String directionId,
  }) : variables = {
          'terms': termIds,
          'directionId': directionId,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {}
}
