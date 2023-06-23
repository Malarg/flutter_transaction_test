import 'dart:async';

import 'package:flutter_transactions_test/src/auth/data/models/tokens.dart';

abstract interface class AuthRepository {
  Future<AuthTokens> authorize(String login, String password);
}