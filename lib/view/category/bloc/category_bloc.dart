import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/model/category.dart';
import 'package:nazmino/bloc/repository/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ICategoryRepository repository;
  CategoryEvent? lastEvent;
  CategoryBloc(this.repository) : super(CategoryLoading()) {
    @override
    void onEvent(CategoryEvent event) {
      super.onEvent(event);
      lastEvent = event;
    }

    on<CategoryStarted>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.getCategories();
        emit(CategorySuccess(categories));
      } catch (e) {
        emit(CategoryError());
      }
    });

    on<AddCategory>((event, emit) async {
      if (state is CategorySuccess) {
        try {
          if (state is CategorySuccess) {
            final current = state as CategorySuccess;
            emit(CategorySuccess(current.categories, isLoading: true));
          }

          await categoryRepository.addCategory(event.name);
          final categories = await categoryRepository.getCategories();
          emit(CategorySuccess(categories));
        } catch (e) {
          emit(CategoryError());
        }
      }
    });

    on<DeleteCategory>((event, emit) async {
      if (state is CategorySuccess) {
        try {
          await repository.deleteCategory(event.id);
          add(CategoryStarted());
        } catch (e) {
          emit(CategoryError());
        }
      }
    });
  }
}
