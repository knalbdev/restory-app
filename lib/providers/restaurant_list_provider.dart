import 'package:flutter/foundation.dart';
import '../data/remote_restaurant_repository.dart';
import '../data/restaurant_repository.dart';
import '../models/restaurant.dart';

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
  final RestaurantRepository _repository;
  RestaurantListState _state = RestaurantListInitial();
  RestaurantListState get state => _state;

  RestaurantListProvider([RestaurantRepository? repository])
      : _repository = repository ?? RemoteRestaurantRepository() {
    fetchRestaurants();
  }

  RestaurantListProvider.withRepository(this._repository);

  Future<void> fetchRestaurants() async {
    _state = RestaurantListLoading();
    notifyListeners();
    try {
      final restaurants = await _repository.getRestaurants();
      _state = RestaurantListSuccess(restaurants);
    } catch (e) {
      _state =
          RestaurantListError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }
}
