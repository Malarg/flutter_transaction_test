import 'package:flutter_transactions_test/src/auth/data/models/tokens.dart';
import 'package:flutter_transactions_test/src/common/key_value_db/app_key_value_db.dart';

/// Required for non mocked implementation. Useless in current stage of the app.
class AuthStorage {
  static const _tokensPrefix = 'tokens_';
  static const _accessTokenKey = '${_tokensPrefix}access';
  static const _refreshTokenKey = '${_tokensPrefix}refresh';
  static const _accessExpiresAtKey = '${_tokensPrefix}access_expires_at';
  static const _refreshExpiresAtKey = '${_tokensPrefix}refresh_expires_at';
  
  final AppKeyValueDb _appKeyValueDb;

  AuthStorage({required AppKeyValueDb appKeyValueDb}) : _appKeyValueDb = appKeyValueDb;

  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _appKeyValueDb.setString(_accessTokenKey, tokens.access),
      _appKeyValueDb.setString(_refreshTokenKey, tokens.refresh),
      _appKeyValueDb.setInt(_accessExpiresAtKey, tokens.accessExpiresIn),
      _appKeyValueDb.setInt(_refreshExpiresAtKey, tokens.refreshExpiresIn),
    ]);
  }

  Future<void> saveUsername(String username) async {
    await _appKeyValueDb.setString('username', username);
  }

  Future<String?> get username async {
    return _appKeyValueDb.getString('username');
  }
}