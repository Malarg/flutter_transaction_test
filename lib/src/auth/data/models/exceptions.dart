sealed class AuthRequestException implements Exception {}

class InvalidCredentialsException extends AuthRequestException {}
