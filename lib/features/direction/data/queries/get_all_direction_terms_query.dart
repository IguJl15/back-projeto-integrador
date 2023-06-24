import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../../term/domain/models/term.dart';

class GetAllDirectionTermsQuery implements QueryParser<List<Term>> {
  @override
  String get queryString => """
SELECT * 
  FROM $termsTable 
  NATURAL JOIN $directionTermsTable dirTerms
WHERE dirTerms.direction_id = @directionId
""";

  @override
  final Map<String, dynamic> variables;

  GetAllDirectionTermsQuery(String directionId)
      : variables = {
          "directionId": directionId,
        };

  @override
  fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {
    return rows
        .map((row) => Term(
              row[termsTable]?['term_id'],
              row[termsTable]?['term_description'],
              row[termsTable]?['is_forbidden'],
            ))
        .toList();
  }
}
