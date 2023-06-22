import '../../../../core/database/query_parser.dart';
import '../../domain/models/term.dart';

class GetAllForbiddenTermsQuery implements QueryParser<List<Term>> {
  static const String _tableName = "terms";

  @override
  String get queryString => """
SELECT * FROM $_tableName t 
WHERE t.is_forbidden = true""";

  @override
  final Map<String, dynamic> variables = {};

  GetAllForbiddenTermsQuery();

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
