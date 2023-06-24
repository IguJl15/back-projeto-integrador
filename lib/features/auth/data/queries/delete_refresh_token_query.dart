import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class DeleteRefreshTokenQuery implements QueryParser<void> {
  @override
  final String queryString = "DELETE FROM $jwtTokensTable WHERE jwt_id = @jwt_id;";
  @override
  final Map<String, dynamic> variables;

  DeleteRefreshTokenQuery(String jwtId)
      : variables = {
          "jwt_id": jwtId,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {}
}
