import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/common/widgets/app_shimmer.dart';

import '../../home/view/home_screen.dart';
import '../state_management/auth_bloc.dart';
import '../state_management/auth_events.dart';
import '../state_management/auth_states.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocConsumer<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            Navigator.of(context).push(HomeScreen.route);
          }
        },
        builder: (BuildContext context, AuthState state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                _UsernameTextField(
                    authBloc: _authBloc, controller: _loginController),
                _PasswordTextField(
                    authBloc: _authBloc, controller: _passwordController),
                if (state is AuthFailure) _ErrorLabel(reason: state.reason),
                Expanded(child: Container()),
                _SubmitButton(
                  formKey: _formKey,
                  authBloc: _authBloc,
                  loginController: _loginController,
                  passwordController: _passwordController,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({
    required AuthBloc authBloc,
    required TextEditingController controller,
  })  : _controller = controller,
        _authBloc = authBloc;

  final AuthBloc _authBloc;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: _validateUsername,
      decoration: InputDecoration(
        labelText: 'auth.login_label'.tr(),
      ),
      onChanged: (_) => _authBloc.add(AuthDataChanged()),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'common.validation.should_not_be_empty'.tr();
    }
    if (!value.contains(RegExp(r'^[A-Za-z0-9]+$'))) {
      return 'auth.must_be_alphanumeric'.tr();
    }
    return null;
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    required AuthBloc authBloc,
    required TextEditingController controller,
  })  : _controller = controller,
        _authBloc = authBloc;

  final AuthBloc _authBloc;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      validator: _validatePassword,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'auth.password_label'.tr(),
      ),
      onChanged: (_) => _authBloc.add(AuthDataChanged()),
    );
  }

  String? _validatePassword(String? value) {
    return switch (value) {
      null || == '' => 'common.validation.should_not_be_empty'.tr(),
      String(length: < 8) => 'auth.password_must_be_at_least_8_characters'.tr(),
      _ => null,
    };
  }
}

class _ErrorLabel extends StatelessWidget {
  const _ErrorLabel({
    required this.reason,
  });

  final AuthFailureReason reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        switch (reason) {
          AuthFailureReason.invalidCredentials =>
            'auth.invalid_credentials'.tr(),
          AuthFailureReason.unknown => 'common.errors.unknown'.tr(),
        },
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required GlobalKey<FormState> formKey,
    required AuthBloc authBloc,
    required TextEditingController loginController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _authBloc = authBloc,
        _loginController = loginController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final AuthBloc _authBloc;
  final TextEditingController _loginController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    final elevatedButton = ElevatedButton(
      onPressed: _authBloc.state is AuthLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _authBloc.add(
                  AuthSubmitted(
                    username: _loginController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
      child: Text('auth.submit'.tr()),
    );
    if (_authBloc.state is AuthLoading) {
      return AppShimmer(
        child: elevatedButton,
      );
    } else {
      return elevatedButton;
    }
  }
}
