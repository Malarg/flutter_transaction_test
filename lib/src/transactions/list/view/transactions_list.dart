import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/models/transaction.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:flutter_transactions_test/src/transactions/list/state_management/transactions_list_cubit.dart';
import 'package:flutter_transactions_test/src/transactions/list/view/transaction_list_tile.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../state_management/transaction_list_state.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  final PagingController<int, Transaction> _pagingController =
      PagingController(firstPageKey: 0);

  late final cubit = TransactionListCubit(context.read<TransactionsInteractor>());

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      cubit.loadNextPage();
    });
    cubit.stream.listen((state) {
      if (state is TransactionPageLoaded) {
        _onPageLoaded(state);
      }
    });
    cubit.deletedIdsStream.listen((id) {
      setState(() {
        _pagingController.itemList?.removeWhere((element) => element.id == id);
      });
    });
    super.initState();
  }

  void _onPageLoaded(TransactionPageLoaded state) {
    if ((_pagingController.itemList?.length ?? 0) +
            state.transactions.length >=
        state.totalTransactionsCount) {
      _pagingController.appendLastPage(state.transactions);
    } else {
      _pagingController.appendPage(
          state.transactions, state.transactions.last.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Transaction>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Transaction>(
        itemBuilder: (context, item, index) => TransactionListTile(
          transaction: item,
        ),
      ),
    );
  }
}
