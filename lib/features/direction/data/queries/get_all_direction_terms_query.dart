import '../../../../core/database/query_parser.dart';
import '../../../term/domain/models/term.dart';

class GetAllDirectionTermsQuery implements QueryParser<List<Term>> {
  static const String _directionTermsTable = "directionterms";
  static const String _termsTable = "terms";

  @override
  String get queryString => """
SELECT * 
  FROM $_termsTable 
  NATURAL JOIN $_directionTermsTable dirTerms
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
              row[_termsTable]?['term_id'],
              row[_termsTable]?['term_description'],
              row[_termsTable]?['is_forbidden'],
            ))
        .toList();
  }
}
