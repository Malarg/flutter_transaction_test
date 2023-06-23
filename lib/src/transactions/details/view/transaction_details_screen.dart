import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:flutter_transactions_test/src/transactions/details/view/transaction_details.dart';

import '../state_management/transaction_details_cubit.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final int transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  static MaterialPageRoute getRoute(int transactionId) => MaterialPageRoute(
        builder: (_) => TransactionDetailsScreen(transactionId: transactionId),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (ctx) => TransactionDetailsCubit(
            transactionId: transactionId,
            transactionsInteractor: ctx.read<TransactionsInteractor>(),
          ),
          child: TransactionDetails(
            transactionId: transactionId,
          ),
        ),
      ),
    );
  }
}
