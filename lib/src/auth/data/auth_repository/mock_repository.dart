import 'dart:async';

import 'package:flutter_transactions_test/src/auth/data/models/exceptions.dart';
import 'package:flutter_transactions_test/src/auth/data/models/tokens.dart';
import 'package:flutter_transactions_test/src/common/constants.dart';
import 'package:flutter_transactions_test/src/common/key_value_db/app_key_value_db.dart';

import 'repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _dbLoginPrefix = 'login_';

  final AppKeyValueDb _appKeyValueDb;

  MockAuthRepository({required AppKeyValueDb appKeyValueDb})
      : _appKeyValueDb = appKeyValueDb;

  /// Simulates authorization request to the server.
  /// If login is not registered yet, it will be registered with the provided password.
  /// If login is already registered, it will be checked against the provided password.
  /// Could throw any implementation of [AuthRequestException].
  @override
  Future<AuthTokens> authorize(String login, String password) async {
    await Future.delayed(mockRequestsDelay);
    
    final loginKey = _dbLoginPrefix + login;
    final loginExists = await _appKeyValueDb.containsKey(loginKey);
    if (!loginExists) {
      await _appKeyValueDb.setString(loginKey, password);
      return AuthTokens.empty();
    }

    final savedPassword = await _appKeyValueDb.getString(loginKey);
    if (savedPassword == password) {
      return AuthTokens.empty();
    } else {
      throw InvalidCredentialsException();
    }
  }
}
