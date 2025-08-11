part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<TransactionCategory> categories;
  final bool isLoading;

  const CategorySuccess(this.categories, {this.isLoading = false});

  @override
  List<Object> get props => [categories, isLoading];
}

final class CategoryError extends CategoryState {}
