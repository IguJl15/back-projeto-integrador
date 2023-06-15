import '../../../../core/database/query_parser.dart';

final class DeleteRefreshTokenQuery implements QueryParser<void> {
  static const _tableName = "jwttokens";

  @override
  final String queryString = "DELETE FROM $_tableName WHERE jwt_id = @jwt_id;";
  @override
  final Map<String, dynamic> variables;

  DeleteRefreshTokenQuery(String jwtId)
      : variables = {
          "jwt_id": jwtId,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {}
}
