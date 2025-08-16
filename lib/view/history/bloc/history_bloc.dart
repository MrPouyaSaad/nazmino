import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nazmino/bloc/model/transaction.dart';

import '../../../bloc/source/history_datasource.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IHistoryDataSource dataSource;

  HistoryBloc(this.dataSource) : super(HistoryLoading()) {
    on<LoadHistory>(_onLoadHistory);
    on<DeleteHistoryItem>(_onDeleteItem);
    on<DeleteAllHistory>(_onDeleteAll);
    on<RestoreHistoryItem>(_onRestoreItem);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final transactions = await dataSource.getAllHistory();
      emit(HistoryLoaded(transactions));
    } catch (e) {
      emit(HistoryLoadError(e.toString()));
    }
  }

  Future<void> _onDeleteItem(
    DeleteHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    if (state is HistoryLoaded) {
      try {
        final currentState = state as HistoryLoaded;
        final List<Transaction> transactions = List.from(
          currentState.transactions,
        );
        final tIndex = transactions.indexWhere((t) => t.id == event.id);
        if (tIndex == -1) return;

        final updatedTransaction = transactions[tIndex].copyWith(
          isLoading: true,
        );
        transactions[tIndex] = updatedTransaction;
        emit(HistoryLoaded(transactions));
        await dataSource.delete(event.id);
        emit(DeleteHistorySuccess(event.id));
        final updatedList = transactions
            .where((t) => t.id != event.id)
            .toList();
        emit(HistoryLoaded(updatedList));
      } catch (e) {
        emit(DeleteHistoryError(e.toString()));
        final currentState = state as HistoryLoaded;
        final List<Transaction> transactions = List.from(
          currentState.transactions,
        );
        emit(HistoryLoaded(transactions));
      }
    }
  }

  Future<void> _onDeleteAll(
    DeleteAllHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(DeleteAllHistoryLoading());
    try {
      await dataSource.deleteAll();
      emit(DeleteAllHistorySuccess());
      add(LoadHistory());
    } catch (e) {
      emit(DeleteAllHistoryError(e.toString()));
      final currentState = state as HistoryLoaded;
      final List<Transaction> transactions = List.from(
        currentState.transactions,
      );
      emit(HistoryLoaded(transactions));
    }
  }

  Future<void> _onRestoreItem(
    RestoreHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      final List<Transaction> transactions = List.from(
        currentState.transactions,
      );

      try {
        final tIndex = transactions.indexWhere((t) => t.id == event.id);
        if (tIndex == -1) return;

        final updatedTransaction = transactions[tIndex].copyWith(
          isLoading: true,
        );
        transactions[tIndex] = updatedTransaction;
        emit(HistoryLoaded(transactions));
        await dataSource.restore(event.id);
        final updatedList = transactions
            .where((t) => t.id != event.id)
            .toList();

        emit(RestoreHistorySuccess(event.id));
        emit(HistoryLoaded(updatedList));
      } catch (e) {
        emit(RestoreHistoryError(e.toString()));
        final currentState = state as HistoryLoaded;
        final List<Transaction> transactions = List.from(
          currentState.transactions,
        );
        emit(HistoryLoaded(transactions));
      }
    }
  }
}
