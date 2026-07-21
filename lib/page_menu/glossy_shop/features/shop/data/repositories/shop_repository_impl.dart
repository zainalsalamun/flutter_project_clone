import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_mock_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopMockDatasource _datasource;

  ShopRepositoryImpl(this._datasource);

  @override
  Future<List<CategoryEntity>> fetchCategories() {
    return _datasource.getCategories();
  }

  @override
  Future<List<ProductEntity>> fetchProducts() {
    return _datasource.getProducts();
  }
}
