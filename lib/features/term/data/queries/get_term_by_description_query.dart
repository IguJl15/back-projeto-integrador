import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/term.dart';

class GetTermsByDescriptionQuery implements QueryParser<List<Term>> {
  @override
  String get queryString => """
SELECT * FROM $termsTable t 
WHERE 
  t.term_description ilike @description
  AND (@withForbidden::boolean OR (NOT t.is_forbidden))
""";

  @override
  final Map<String, dynamic> variables;

  GetTermsByDescriptionQuery(String description, bool allowForbidden)
      : variables = {'description': description, 'withForbidden': allowForbidden};

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
