import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

sealed class RestaurantDetailState {}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {}

class RestaurantDetailSuccess extends RestaurantDetailState {
  final RestaurantDetail restaurant;

  RestaurantDetailSuccess(this.restaurant);
}

class RestaurantDetailError extends RestaurantDetailState {
  final String message;

  RestaurantDetailError(this.message);
}

class RestaurantDetailProvider extends ChangeNotifier {
  RestaurantDetailState _state = RestaurantDetailInitial();

  RestaurantDetailState get state => _state;

  Future<void> fetchDetail(String id) async {
    _state = RestaurantDetailLoading();
    notifyListeners();
    try {
      final detail = await ApiService.getRestaurantDetail(id);
      _state = RestaurantDetailSuccess(detail);
    } catch (e) {
      _state = RestaurantDetailError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  Future<void> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final reviews =
          await ApiService.addReview(id: id, name: name, review: review);
      if (_state is RestaurantDetailSuccess) {
        final current = (_state as RestaurantDetailSuccess).restaurant;
        _state = RestaurantDetailSuccess(
          RestaurantDetail(
            id: current.id,
            name: current.name,
            description: current.description,
            pictureId: current.pictureId,
            city: current.city,
            address: current.address,
            rating: current.rating,
            categories: current.categories,
            menus: current.menus,
            customerReviews: reviews,
          ),
        );
        notifyListeners();
      }
    } catch (_) {
      rethrow;
    }
  }
}
