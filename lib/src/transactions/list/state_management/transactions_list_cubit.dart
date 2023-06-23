import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:flutter_transactions_test/src/transactions/list/state_management/transaction_list_state.dart';

class TransactionListCubit extends Cubit<TransactionListState> {
  final TransactionsInteractor _transactionsInteractor;
  int _currentMaxId = 0;

  late final deletedIdsStream = _transactionsInteractor.deletedIdsStream;

  TransactionListCubit(
    TransactionsInteractor transactionsInteractor,
  )   : _transactionsInteractor = transactionsInteractor,
        super(TransactionListLoading());

  Future<void> loadNextPage() async {
    final page =
        await _transactionsInteractor.getTransactions(_currentMaxId, 20);
    _currentMaxId = page.transactions.last.id;
    emit(
      TransactionPageLoaded(
        transactions: page.transactions,
        totalTransactionsCount: page.totalTransactionsCount,
      ),
    );
  }
}
