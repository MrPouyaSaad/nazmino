part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionsListScreenStarted extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final String transactionId;

  DeleteTransaction(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class DeleteAllTransactions extends TransactionEvent {}

class FilterByCategory extends TransactionEvent {
  final String? categoryId;

  FilterByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
