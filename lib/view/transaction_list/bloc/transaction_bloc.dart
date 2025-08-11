import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/model/category.dart';
import 'package:nazmino/bloc/model/transaction.dart';
import 'package:nazmino/bloc/repository/transaction_repo.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ITransactionRepository _transactionRepository;
  String? selectedCategory;

  // لیست اصلی تراکنش‌ها که همیشه کامل باقی می‌مونه
  List<Transaction> _allTransactions = [];

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
      _allTransactions = transactions; // ذخیره لیست اصلی
      emit(TransactionLoaded(transactions: transactions));
    } catch (_) {
      emit(TransactionError());
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      try {
        emit(AddTransactionLoading());
        final newTransactions = await _transactionRepository.addTransactions(
          event.transaction,
        );
        _allTransactions = newTransactions; // آپدیت لیست اصلی
        emit(AddTransactionSuccess());
        emit(TransactionLoaded(transactions: newTransactions));
      } catch (_) {
        emit(TransactionError());
      }
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    if (state is TransactionLoaded) {
      try {
        final currentState = state as TransactionLoaded;
        final List<Transaction> transactions = List.from(
          currentState.transactions,
        );

        final tIndex = transactions.indexWhere(
          (t) => t.id == event.transactionId,
        );
        if (tIndex == -1) return;

        final updatedTransaction = transactions[tIndex].copyWith(
          isLoading: true,
        );
        transactions[tIndex] = updatedTransaction;

        emit(TransactionLoaded(transactions: transactions));

        await _transactionRepository.remove(event.transactionId);

        final updatedList = transactions
            .where((t) => t.id != event.transactionId)
            .toList();

        _allTransactions = _allTransactions
            .where((t) => t.id != event.transactionId)
            .toList(); // آپدیت لیست اصلی

        emit(TransactionLoaded(transactions: updatedList));
      } catch (_) {
        emit(TransactionDeleteError());
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
        _allTransactions = []; // خالی کردن لیست اصلی
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
      final isAll = event.category.name == 'All';

      if (isAll) {
        emit(TransactionLoaded(transactions: _allTransactions));
      } else {
        final filtered = _allTransactions
            .where((t) => t.categoryId == event.category.id)
            .toList();
        selectedCategory = event.category.id;
        emit(TransactionLoaded(transactions: filtered));
      }
    }
  }
}
