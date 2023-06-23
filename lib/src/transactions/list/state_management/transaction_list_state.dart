import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';

sealed class TransactionListState {}

class TransactionListLoading extends TransactionListState {}

class TransactionPageLoaded extends TransactionListState {
  final List<Transaction> transactions;
  final int totalTransactionsCount;

  TransactionPageLoaded({
    required this.transactions,
    required this.totalTransactionsCount,
  });
}

class TransactionListError extends TransactionListState {
  final String message;

  TransactionListError({
    required this.message,
  });
}
