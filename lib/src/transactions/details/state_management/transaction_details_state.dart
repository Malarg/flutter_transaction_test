sealed class TransactionDetailsState {}

class TransactionDetailsInitial extends TransactionDetailsState {}

class TransactionDetailsCancelled extends TransactionDetailsState {}

class TransactionDetailsCancellationLoading extends TransactionDetailsState {}

class TransactionDetailsCancellationError extends TransactionDetailsState {}