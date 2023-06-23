class AuthTokens {
  final String access;
  final String refresh;
  final int accessExpiresIn;
  final int refreshExpiresIn;

  AuthTokens({
    required this.access,
    required this.refresh,
    required this.accessExpiresIn,
    required this.refreshExpiresIn,
  });

  AuthTokens.empty()
      : access = '',
        refresh = '',
        accessExpiresIn = 0,
        refreshExpiresIn = 0;
}