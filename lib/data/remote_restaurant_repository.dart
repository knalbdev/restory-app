import '../data/restaurant_repository.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RemoteRestaurantRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurants() => ApiService.getRestaurants();
}
