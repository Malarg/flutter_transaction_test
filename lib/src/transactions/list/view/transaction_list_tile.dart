import 'package:flutter/material.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction_type.dart';
import 'package:flutter_transactions_test/src/transactions/common/utils.dart';

import '../../details/view/transaction_details_screen.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction _transaction;

  const TransactionListTile({
    super.key,
    required Transaction transaction,
  }) : _transaction = transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          TransactionDetailsScreen.getRoute(_transaction.id),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TransactionType(type: _transaction.type),
                    Text(
                      _transaction.id.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Text(
                _transaction.amount.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionType extends StatelessWidget {
  final TransactionType _type;

  const _TransactionType({
    required TransactionType type,
  }) : _type = type;

  @override
  Widget build(BuildContext context) {
    return Text(
      TransactionUtils.getLocalizedTypeString(_type),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _getTransactionColor(context, _type),
          ),
    );
  }

  Color _getTransactionColor(BuildContext context, TransactionType type) {
    return switch (type) {
      TransactionType.deposit => Colors.green,
      TransactionType.transfer => Colors.black,
      TransactionType.withdrawal => Colors.red,
    };
  }
}
