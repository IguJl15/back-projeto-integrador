import '../../../../core/database/query_parser.dart';

final class InsertDirectionsTerms implements QueryParser<void> {
  static const _tableName = "DirectionTerms";

  @override
  final String queryString = """
INSERT INTO $_tableName(term_id, direction_id)
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
