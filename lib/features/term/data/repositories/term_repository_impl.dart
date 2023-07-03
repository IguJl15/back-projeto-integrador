import '../../../../core/database/database.dart';
import '../../domain/models/term.dart';
import '../../domain/repositories/term_repository.dart';
import '../queries/create_terms_query.dart';
import '../queries/get_all_forbidden_terms_query.dart';
import '../queries/get_all_terms_query.dart';
import '../queries/get_term_by_description_query.dart';

class TermRepositoryImpl implements TermRepository {
  final DatabaseConnection dbConnection;

  TermRepositoryImpl({required this.dbConnection});

  @override
  Future<List<Term>> getAllTerms() {
    return dbConnection.query(GetAllTermsQuery());
  }

  @override
  Future<List<Term>> getForbiddenTerms() async {
    return await dbConnection.query(GetAllForbiddenTermsQuery());
  }

  @override
  Future<Term?> getTermByDescriptionOrNull(String description, [bool fetchForbidden = false]) async {
    final query = GetTermsByDescriptionQuery(description, fetchForbidden);
    List<Term> termsFound = await dbConnection.query(query);

    return termsFound.firstOrNull;
  }

  @override
  Future<Term> saveTerm(Term term) async {
    final query = CreateTermsQuery([term.description]);

    final termsCreated = await dbConnection.query(query);

    return termsCreated.single;
  }

  @override
  Future<List<Term>> saveAllTerms(List<Term> terms) async {
    final query = CreateTermsQuery(terms.map((e) => e.description).toList());

    return await dbConnection.query(query);
  }
}
