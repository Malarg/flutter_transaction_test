import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/auth/data/auth_repository/mock_repository.dart';
import 'package:flutter_transactions_test/src/auth/data/auth_storage.dart';
import 'package:flutter_transactions_test/src/auth/domain/auth_interactor.dart';
import 'package:flutter_transactions_test/src/auth/view/auth_form.dart';
import 'package:flutter_transactions_test/src/common/key_value_db/app_key_value_db.dart';
import 'package:provider/provider.dart';

import '../data/auth_repository/repository.dart';
import '../state_management/auth_bloc.dart';

class LogicScreen extends StatelessWidget {
  const LogicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            Provider<AuthRepository>(
              create: (ctx) => MockAuthRepository(
                appKeyValueDb: ctx.read<AppKeyValueDb>(),
              ),
            ),
            Provider<AuthInteractor>(
              create: (ctx) => AuthInteractor(
                tokensStorage: ctx.read<AuthStorage>(),
                authRepository: ctx.read<AuthRepository>(),
              ),
            ),
            BlocProvider(
              create: (ctx) => AuthBloc(
                authInteractor: ctx.read<AuthInteractor>(),
              ),
            ),
          ],
          child: const AuthForm(),
        ),
      ),
    );
  }
}
