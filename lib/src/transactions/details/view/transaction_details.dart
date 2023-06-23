import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/common/widgets/app_shimmer.dart';
import 'package:flutter_transactions_test/src/common/widgets/loadable_data_widget.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/detailed_transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/utils.dart';
import 'package:flutter_transactions_test/src/transactions/details/state_management/transaction_details_state.dart';

import '../state_management/transaction_details_cubit.dart';

class TransactionDetails extends StatefulWidget {
  final int transactionId;

  const TransactionDetails({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late final cubit = context.read<TransactionDetailsCubit>();

  @override
  Widget build(BuildContext context) {
    return LoadableDataWidget<DetailedTransaction>(
      retrieveDataFunction: () => cubit.loadTransaction(),
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidget: Center(child: Text('transaction.failed_to_load'.tr())),
      dataWidget: (DetailedTransaction transaction) =>
          BlocBuilder<TransactionDetailsCubit, TransactionDetailsState>(
        bloc: cubit,
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('transaction.number'.tr()),
                          subtitle: Text(
                            transaction.id.toString(),
                          ),
                        ),
                        ListTile(
                          title: Text('transaction.type_title'.tr()),
                          subtitle: Text(
                            TransactionUtils.getLocalizedTypeString(transaction.type),
                          ),
                        ),
                        ListTile(
                          title: Text('transaction.date'.tr()),
                          subtitle: Text(
                            transaction.date.toString(),
                          ),
                        ),
                        ListTile(
                          title: Text('transaction.amount'.tr()),
                          subtitle: Text(
                            transaction.amount.toStringAsFixed(2),
                          ),
                        ),
                        ListTile(
                          title: Text('transaction.fee'.tr()),
                          subtitle: Text(
                            transaction.fee.toStringAsFixed(2),
                          ),
                        ),
                        ListTile(
                          title: Text('transaction.total'.tr()),
                          subtitle: Text(
                            (transaction.amount - transaction.fee).toStringAsFixed(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _CancelButton(cubit: cubit, state: state),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.cubit, required this.state});

  final TransactionDetailsCubit cubit;
  final TransactionDetailsState state;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: state is TransactionDetailsCancellationLoading
          ? null
          : cubit.deleteTransaction,
      child: Text('transaction.delete'.tr()),
    );
    final loadingButton = AppShimmer(child: button);
    final cancelledText = Text('transaction.deleted'.tr());
    final cancellationErrorText = Text('transaction.delete_failed'.tr());

    return switch (state) {
      TransactionDetailsInitial() => button,
      TransactionDetailsCancellationLoading() => loadingButton,
      TransactionDetailsCancelled() => cancelledText,
      TransactionDetailsCancellationError() => cancellationErrorText,
    };
  }
}
