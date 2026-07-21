import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class ShopRepository {
  Future<List<CategoryEntity>> fetchCategories();
  Future<List<ProductEntity>> fetchProducts();
}
