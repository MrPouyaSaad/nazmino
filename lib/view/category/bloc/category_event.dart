part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class CategoryStarted extends CategoryEvent {}

final class AddCategory extends CategoryEvent {
  final String name;

  const AddCategory(this.name);

  @override
  List<Object> get props => [name];
}

final class DeleteCategory extends CategoryEvent {
  final String id;

  const DeleteCategory(this.id);

  @override
  List<Object> get props => [id];
}

class SelectCategoryEvent extends CategoryEvent {
  final TransactionCategory category;
  const SelectCategoryEvent(this.category);
}
