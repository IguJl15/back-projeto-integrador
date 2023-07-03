import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class InsertDirectionsTerms implements QueryParser<void> {
  @override
  final String queryString = """
INSERT INTO $directionTermsTable(term_id, direction_id, is_exclusion_term)
        SELECT
            l.element,
            @directionId,
            @exclusionTerm
        FROM
            (select unnest('@terms'::uuid[])) as l(element)
        ON CONFLICT DO NOTHING;
""";
  @override
  final Map<String, dynamic> variables;

  InsertDirectionsTerms({
    required List<String> termIds,
    required String directionId,
    bool exclusionTerm = false,
  }) : variables = {
          'terms': termIds,
          'directionId': directionId,
          'exclusionTerm': exclusionTerm,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {}
}
