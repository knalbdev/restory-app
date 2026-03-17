import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

sealed class RestaurantListState {}

class RestaurantListInitial extends RestaurantListState {}

class RestaurantListLoading extends RestaurantListState {}

class RestaurantListSuccess extends RestaurantListState {
  final List<Restaurant> restaurants;

  RestaurantListSuccess(this.restaurants);
}

class RestaurantListError extends RestaurantListState {
  final String message;

  RestaurantListError(this.message);
}

class RestaurantListProvider extends ChangeNotifier {
  RestaurantListState _state = RestaurantListInitial();

  RestaurantListState get state => _state;

  RestaurantListProvider() {
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    _state = RestaurantListLoading();
    notifyListeners();
    try {
      final restaurants = await ApiService.getRestaurants();
      _state = RestaurantListSuccess(restaurants);
    } catch (e) {
      _state =
          RestaurantListError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }
}
