sealed class AuthState {}

class AuthEditData extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {}

class AuthFailure extends AuthState {
  final AuthFailureReason reason;

  AuthFailure({required this.reason});
}

enum AuthFailureReason {
  invalidCredentials,
  unknown,
}