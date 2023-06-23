import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';

class TransactionPage {
  final List<Transaction> transactions;
  final int totalTransactionsCount;

  TransactionPage({
    required this.transactions,
    required this.totalTransactionsCount,
  });
}
