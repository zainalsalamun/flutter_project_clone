import '../../../core/network/api_client.dart';
import '../../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource({required this.apiClient});

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await apiClient.dio.get('/products');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/products/categories');
      final List data = response.data;
      return data.cast<String>();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await apiClient.dio.get('/products/category/$category');
      final List data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product details: $e');
    }
  }
}
