import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_transactions_test/src/auth/data/auth_storage.dart';
import 'package:flutter_transactions_test/src/auth/view/auth_screen.dart';
import 'package:flutter_transactions_test/src/common/key_value_db/app_key_value_db.dart';
import 'package:flutter_transactions_test/src/transactions/common/data/repository/local_transactions_repository.dart';
import 'package:flutter_transactions_test/src/transactions/common/domain/transactions_interactor.dart';
import 'package:provider/provider.dart';

import 'src/common/key_value_db/prefs_key_value_db.dart';
import 'src/transactions/common/data/repository/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: YamlAssetLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppKeyValueDb>(create: (ctx) => PrefsKeyValueDb()),
        Provider<AuthStorage>(
            create: (ctx) =>
                AuthStorage(appKeyValueDb: ctx.read<AppKeyValueDb>())),
        Provider<TransactionsRepository>(
          create: (ctx) => SqfliteTransactionsRepository(
            authStorage: ctx.read<AuthStorage>(),
          ),
        ),
        Provider<TransactionsInteractor>(
          create: (ctx) => TransactionsInteractor(
            ctx.read<TransactionsRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LogicScreen(),
      ),
    );
  }
}
