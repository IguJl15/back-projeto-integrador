class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens(
    this.accessToken,
    this.refreshToken,
  );

  toMap() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }
}
