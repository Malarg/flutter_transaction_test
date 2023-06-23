sealed class AuthEvent {}

class AuthSubmitted extends AuthEvent {
  final String username;
  final String password;

  AuthSubmitted({required this.username, required this.password});
}

class AuthDataChanged extends AuthEvent {
  AuthDataChanged();
}
