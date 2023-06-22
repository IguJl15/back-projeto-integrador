import '../../../../core/database/query_parser.dart';

import '../../domain/models/term.dart';

class GetTermsByDescriptionQuery implements QueryParser<List<Term>> {
  static const String _tableName = "terms";

  @override
  String get queryString => """
SELECT * FROM $_tableName t 
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
            row[_tableName]?['term_id'],
            row[_tableName]?['term_description'],
            row[_tableName]?['is_forbidden'],
          ),
        )
        .toList();
  }
}
