import 'package:flutter_transactions_test/src/auth/data/auth_repository/repository.dart';
import 'package:flutter_transactions_test/src/auth/data/auth_storage.dart';

class AuthInteractor {
  final AuthRepository _authRepository;
  final AuthStorage _tokensStorage;

  AuthInteractor({
    required AuthRepository authRepository,
    required AuthStorage tokensStorage,
  })  : _authRepository = authRepository,
        _tokensStorage = tokensStorage;

  Future<void> authorize(String login, String password) async {
    try {
      final tokens = await _authRepository.authorize(login, password);
      await _tokensStorage.saveTokens(tokens);
      await _tokensStorage.saveUsername(login);
    } catch (_) {
      rethrow;
    }
  }
}
