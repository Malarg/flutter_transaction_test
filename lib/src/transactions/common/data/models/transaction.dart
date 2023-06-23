import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_type.dart';

class Transaction {
  final int id;
  final TransactionType type;
  final double amount;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
  });
}
