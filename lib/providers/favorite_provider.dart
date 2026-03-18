import 'package:flutter/foundation.dart';
import '../data/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  FavoriteProvider() {
    loadFavorites();
  }

  /// Constructor khusus untuk testing — tidak memanggil loadFavorites.
  FavoriteProvider.forTest();

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHelper.getFavorites();
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((r) => r.id == id);

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await DatabaseHelper.removeFavorite(restaurant.id);
    } else {
      await DatabaseHelper.addFavorite(restaurant);
    }
    await loadFavorites();
  }
}
