import 'package:flutter_transactions_test/src/transactions/common/data/models/account_info.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/detailed_transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_page.dart';

abstract interface class TransactionsRepository {
  Future<AccountInfo> getAccountInfo();
  Future<TransactionPage> getTransactions(int offset, int limit);
  Future<DetailedTransaction> getTransactionDetails(int id);
  Future<AccountInfo> deleteTransaction(int id);
}
