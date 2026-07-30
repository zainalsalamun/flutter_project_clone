import '../datasources/remote/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository({required this.remoteDataSource});

  Future<List<ProductModel>> getAllProducts() => remoteDataSource.getAllProducts();
  Future<List<String>> getCategories() => remoteDataSource.getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category) => remoteDataSource.getProductsByCategory(category);
  Future<ProductModel> getProductById(int id) => remoteDataSource.getProductById(id);
}
