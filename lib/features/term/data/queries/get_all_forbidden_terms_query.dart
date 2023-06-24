import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/term.dart';

class GetAllForbiddenTermsQuery implements QueryParser<List<Term>> {
  @override
  String get queryString => """
SELECT * FROM $termsTable t 
WHERE t.is_forbidden = true""";

  @override
  final Map<String, dynamic> variables = {};

  GetAllForbiddenTermsQuery();

  @override
  List<Term> fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {
    return rows
        .map(
          (row) => Term(
            row[termsTable]?['term_id'],
            row[termsTable]?['term_description'],
            row[termsTable]?['is_forbidden'],
          ),
        )
        .toList();
  }
}
