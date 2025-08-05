import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/bloc/repository/transaction_repo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ITransactionRepository _transactionRepository;

  TransactionBloc(this._transactionRepository) : super(TransactionLoading()) {
    on<TransactionsListScreenStarted>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<DeleteAllTransactions>(_onDeleteAllTransactions);
    on<FilterByCategory>(_onFilterByCategory);
  }

  Future<void> _onLoadTransactions(
    TransactionsListScreenStarted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final transactions = await _transactionRepository.getTransactions();
      emit(TransactionLoaded(transactions: transactions));
    } catch (_) {
      emit(TransactionError());
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      emit(AddTransactionLoading());
      await _transactionRepository.addTransactions(event.transaction);
      emit(AddTransactionSuccess());
      add(TransactionsListScreenStarted()); // refresh after adding
    } catch (_) {
      emit(TransactionError());
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      try {
        await _transactionRepository.remove(event.transactionId);
        add(TransactionsListScreenStarted());
      } catch (_) {
        emit(TransactionError());
      }
    }
  }

  Future<void> _onDeleteAllTransactions(
    DeleteAllTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      try {
        await _transactionRepository.removeAll();
        add(TransactionsListScreenStarted());
      } catch (_) {
        emit(TransactionError());
      }
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      final current = (state as TransactionLoaded).transactions;
      if (event.categoryId == null) {
        emit(TransactionLoaded(transactions: current)); // all
      } else {
        final filtered = current
            .where((t) => t.categoryId == event.categoryId)
            .toList();
        emit(TransactionLoaded(transactions: filtered));
      }
    }
  }
}
