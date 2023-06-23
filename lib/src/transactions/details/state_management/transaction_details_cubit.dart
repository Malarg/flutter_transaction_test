import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/detailed_transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:flutter_transactions_test/src/transactions/details/state_management/transaction_details_state.dart';

class TransactionDetailsCubit extends Cubit<TransactionDetailsState> {
  TransactionDetailsCubit({
    required this.transactionId,
    required this.transactionsInteractor,
  }) : super(TransactionDetailsInitial());

  final int transactionId;
  final TransactionsInteractor transactionsInteractor;

  Future<DetailedTransaction> loadTransaction() async {
    return transactionsInteractor.getTransactionDetails(transactionId);
  }

  Future<void> deleteTransaction() async {
    emit(TransactionDetailsCancellationLoading());
    try {
      await transactionsInteractor.deleteTransaction(transactionId);
      emit(TransactionDetailsCancelled());
    } catch (e) {
      emit(TransactionDetailsCancellationError());
    }
  }
}
