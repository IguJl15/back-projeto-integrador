import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';

final class SaveRefreshTokenQuery implements QueryParser<void> {
  @override
  final String queryString = "INSERT INTO $jwtTokensTable (jwt_id, user_id) values (@jwt_id, @user_id);";
  @override
  final Map<String, dynamic> variables;

  SaveRefreshTokenQuery(String jwtId, String userId)
      : variables = {
          "jwt_id": jwtId,
          "user_id": userId,
        };

  @override
  void fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> rows) {}
}
