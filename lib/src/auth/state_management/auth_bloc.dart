import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_transactions_test/src/auth/data/models/exceptions.dart';
import 'package:flutter_transactions_test/src/auth/domain/auth_interactor.dart';

import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthInteractor _authInteractor;

  AuthBloc({required AuthInteractor authInteractor})
      : _authInteractor = authInteractor,
        super(AuthEditData()) {
    on<AuthSubmitted>(_onAuthSubmitted);
    on<AuthDataChanged>(_onAuthDataChanged);
  }

  Future<void> _onAuthSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authInteractor.authorize(event.username, event.password);
      emit(AuthLoggedIn());
    } on AuthRequestException catch (e) {
      switch (e) {
        case InvalidCredentialsException():
          emit(AuthFailure(reason: AuthFailureReason.invalidCredentials));
      }
    } catch (e) {
      emit(AuthFailure(reason: AuthFailureReason.unknown));
    }
  }

  void _onAuthDataChanged(
    AuthDataChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthEditData());
  }
}
