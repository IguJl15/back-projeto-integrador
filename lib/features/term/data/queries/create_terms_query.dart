import '../../../../core/database/query_parser.dart';
import '../../domain/models/term.dart';

class CreateTermsQuery implements QueryParser<List<Term>> {
  static const String _tableName = "terms";

  @override
  String get queryString => """
INSERT INTO $_tableName(term_description, is_forbidden)
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
            row[_tableName]?['term_id'],
            row[_tableName]?['term_description'],
            row[_tableName]?['is_forbidden'],
          ),
        )
        .toList();
  }
}
