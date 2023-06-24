import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../../domain/models/term.dart';

class CreateTermsQuery implements QueryParser<List<Term>> {
  @override
  String get queryString => """
INSERT INTO $termsTable(term_description, is_forbidden)
values (unnest(@terms::text[]), false)
returning *;
""";

  @override
  final Map<String, dynamic> variables;

  CreateTermsQuery(List<String> termsDescriptions)
      : variables = {
          'terms': termsDescriptions,
        };

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
