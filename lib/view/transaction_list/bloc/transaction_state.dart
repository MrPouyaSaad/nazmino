part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {}

class TransactionDeleteLoading extends TransactionState {}

class TransactionDeleteSuccess extends TransactionState {}

class TransactionDeleteError extends TransactionState {}

class AddTransactionLoading extends TransactionState {}

class AddTransactionSuccess extends TransactionState {}

class AddTransactionError extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionError extends TransactionState {}
