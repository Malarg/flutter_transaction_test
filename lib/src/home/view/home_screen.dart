import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_transactions_test/src/account/view/account_widget.dart';
import 'package:flutter_transactions_test/src/transactions/list/view/transactions_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const Expanded(
              child: TabBarView(
                children: [
                  TransactionsList(),
                  AccountWidget(),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: 'home.transactions'.tr()),
                Tab(text: 'home.account'.tr()),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
