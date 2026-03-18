import '../models/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
}
