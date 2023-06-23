import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/account/state_management/account_cubit.dart';
import 'package:flutter_transactions_test/src/account/state_management/account_state.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({Key? key}) : super(key: key);

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  late final accountCubit =
      AccountCubit(context.read<TransactionsInteractor>());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<AccountCubit, AccountState>(
        bloc: accountCubit,
        builder: (BuildContext context, AccountState state) {
          if (state is AccountDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AccountDataError) {
            return const Center(child: Text('Error'));
          }

          if (state is! AccountDataLoaded) {
            throw Exception('Unknown state: $state');
          }

          final info = state.account;

          final incomePercent = info.totalIncome /
              (info.totalIncome + info.totalWithdrawal) *
              100;
          final withdrawalPercent = info.totalWithdrawal /
              (info.totalIncome + info.totalWithdrawal) *
              100;

          final pieData = <_PieData>[
            _PieData(
              'Income',
              incomePercent,
              'Income \n ${incomePercent.toStringAsFixed(2)}%',
            ),
            _PieData(
              'Withdrawal',
              withdrawalPercent,
              'Withdrawal \n ${withdrawalPercent.toStringAsFixed(2)}%',
            ),
          ];

          return SfCircularChart(
            legend: const Legend(isVisible: true),
            series: <PieSeries<_PieData, String>>[
              PieSeries<_PieData, String>(
                  explode: true,
                  explodeIndex: 0,
                  dataSource: pieData,
                  xValueMapper: (_PieData data, _) => data.xData,
                  yValueMapper: (_PieData data, _) => data.yData,
                  dataLabelMapper: (_PieData data, _) => data.text,
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ],
          );
        },
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text = '']);
  final String xData;
  final num yData;
  final String text;
}
