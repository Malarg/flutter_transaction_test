import '../../transactions/common/data/models/account_info.dart';

sealed class AccountState {}

class AccountDataLoading extends AccountState {}

class AccountDataError extends AccountState {}

class AccountDataLoaded extends AccountState {
  AccountDataLoaded({required this.account});

  final AccountInfo account;
}
