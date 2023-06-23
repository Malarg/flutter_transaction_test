import 'dart:async';

import 'package:flutter_transactions_test/src/transactions/common/data/models/account_info.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/detailed_transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_page.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/repository/repository.dart';

class TransactionsInteractor {
  final TransactionsRepository _transactionsRepository;

  TransactionsInteractor(this._transactionsRepository);

  final _deletedIdStreamController = StreamController<int>.broadcast();
  Stream<int> get deletedIdsStream => _deletedIdStreamController.stream;

  Future<TransactionPage> getTransactions(int offset, int limit) async {
    return await _transactionsRepository.getTransactions(offset, limit);
  }

  Future<AccountInfo> deleteTransaction(int id) async {
    final accountInfo = await _transactionsRepository.deleteTransaction(id);
    _deletedIdStreamController.add(id);
    return accountInfo;
  }

  Future<DetailedTransaction> getTransactionDetails(int id) async {
    return await _transactionsRepository.getTransactionDetails(id);
  }

  Future<AccountInfo> getAccountInfo() async {
    final info = await _transactionsRepository.getAccountInfo();
    return info;
  }
}