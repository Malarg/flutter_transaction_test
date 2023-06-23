import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';

import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final TransactionsInteractor _transactionsInteractor;

  AccountCubit(
    TransactionsInteractor transactionsInteractor,
  )   : _transactionsInteractor = transactionsInteractor,
        super(AccountDataLoading()) {
    loadAccountInfo();
  }

  Future<void> loadAccountInfo() async {
    emit(AccountDataLoading());
    try {
      final account = await _transactionsInteractor.getAccountInfo();
      emit(AccountDataLoaded(account: account));
    } catch (e) {
      emit(AccountDataError());
    }
  }
}
