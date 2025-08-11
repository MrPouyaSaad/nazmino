import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/model/transaction.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

// ---------- Action State ----------
abstract class HistoryActionState extends HistoryState {
  const HistoryActionState();

  @override
  List<Object?> get props => [];
}

// ---------- Load History ----------
class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Transaction> transactions;
  const HistoryLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class HistoryLoadError extends HistoryState {
  final String message;
  const HistoryLoadError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------- Delete One ----------

class DeleteHistorySuccess extends HistoryActionState {
  final String id;
  const DeleteHistorySuccess(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteHistoryError extends HistoryActionState {
  final String message;
  const DeleteHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------- Delete All ----------
class DeleteAllHistoryLoading extends HistoryActionState {}

class DeleteAllHistorySuccess extends HistoryActionState {}

class DeleteAllHistoryError extends HistoryActionState {
  final String message;
  const DeleteAllHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// ---------- Restore ----------

class RestoreHistorySuccess extends HistoryActionState {
  final String id;
  const RestoreHistorySuccess(this.id);

  @override
  List<Object?> get props => [id];
}

class RestoreHistoryError extends HistoryActionState {
  final String message;
  const RestoreHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
