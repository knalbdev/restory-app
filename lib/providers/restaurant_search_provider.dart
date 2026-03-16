import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

sealed class RestaurantSearchState {}

class RestaurantSearchInitial extends RestaurantSearchState {}

class RestaurantSearchLoading extends RestaurantSearchState {}

class RestaurantSearchSuccess extends RestaurantSearchState {
  final List<Restaurant> restaurants;

  RestaurantSearchSuccess(this.restaurants);
}

class RestaurantSearchError extends RestaurantSearchState {
  final String message;

  RestaurantSearchError(this.message);
}

class RestaurantSearchProvider extends ChangeNotifier {
  RestaurantSearchState _state = RestaurantSearchInitial();

  RestaurantSearchState get state => _state;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _state = RestaurantSearchInitial();
      notifyListeners();
      return;
    }
    _state = RestaurantSearchLoading();
    notifyListeners();
    try {
      final restaurants = await ApiService.searchRestaurants(query.trim());
      _state = RestaurantSearchSuccess(restaurants);
    } catch (e) {
      _state = RestaurantSearchError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }
}
