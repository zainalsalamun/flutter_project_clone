import '../../core/utils/dummy_data.dart';
import '../models/restaurant_model.dart';

class RestaurantRepository {
  Future<List<RestaurantModel>> getNearbyRestaurants() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return DummyData.getRestaurants();
  }

  Future<RestaurantModel> getRestaurantDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.getRestaurants().firstWhere((element) => element.id == id);
  }
}
