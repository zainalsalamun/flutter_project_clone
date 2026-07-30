import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

// --- Events ---
abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class FetchAllProducts extends ProductEvent {}
class FetchCategories extends ProductEvent {}
class FetchProductsByCategory extends ProductEvent {
  final String category;
  FetchProductsByCategory(this.category);
  @override
  List<Object?> get props => [category];
}

// --- States ---
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categories;
  ProductLoaded({this.products = const [], this.categories = const []});
  @override
  List<Object?> get props => [products, categories];
}
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  
  List<ProductModel> _allProductsCache = [];
  List<String> _categoriesCache = [];

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<FetchAllProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        if (_allProductsCache.isEmpty) {
          _allProductsCache = await repository.getAllProducts();
        }
        if (_categoriesCache.isEmpty) {
          _categoriesCache = await repository.getCategories();
        }
        emit(ProductLoaded(products: _allProductsCache, categories: _categoriesCache));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<FetchCategories>((event, emit) async {
      try {
        _categoriesCache = await repository.getCategories();
        if (state is ProductLoaded) {
          final currentState = state as ProductLoaded;
          emit(ProductLoaded(products: currentState.products, categories: _categoriesCache));
        } else {
          emit(ProductLoaded(categories: _categoriesCache));
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<FetchProductsByCategory>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.getProductsByCategory(event.category);
        emit(ProductLoaded(products: products, categories: _categoriesCache));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
