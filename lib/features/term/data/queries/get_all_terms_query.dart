import 'package:back_projeto_integrador/core/database/query_parser.dart';

import '../../../../core/database/tables.dart';
import '../../domain/models/term.dart';

class GetAllTermsQuery implements QueryParser<List<Term>> {
  @override
  String get queryString => """SELECT * FROM $termsTable t""";

  @override
  final Map<String, dynamic> variables = {};

  GetAllTermsQuery();

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
