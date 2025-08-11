import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {}

class DeleteHistoryItem extends HistoryEvent {
  final String id;

  const DeleteHistoryItem(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllHistory extends HistoryEvent {}

class RestoreHistoryItem extends HistoryEvent {
  final String id;

  const RestoreHistoryItem(this.id);

  @override
  List<Object?> get props => [id];
}
