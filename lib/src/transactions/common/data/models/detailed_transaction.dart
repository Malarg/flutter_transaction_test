import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';

class DetailedTransaction extends Transaction {
  final DateTime date;
  final double fee;

  DetailedTransaction({
    required super.id,
    required super.type,
    required super.amount,
    required this.date,
    required this.fee,
  });
}
