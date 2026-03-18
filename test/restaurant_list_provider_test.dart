import 'package:flutter_test/flutter_test.dart';
import 'package:restory_app/data/restaurant_repository.dart';
import 'package:restory_app/models/restaurant.dart';
import 'package:restory_app/providers/restaurant_list_provider.dart';

class _SuccessRepository implements RestaurantRepository {
  final List<Restaurant> data;
  _SuccessRepository(this.data);
  @override
  Future<List<Restaurant>> getRestaurants() async => data;
}

class _ErrorRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurants() async =>
      throw Exception('Tidak ada koneksi internet.');
}

final _fakeRestaurants = [
  Restaurant(
    id: '1',
    name: 'Kafe Kita',
    description: 'Restoran enak',
    pictureId: 'abc',
    city: 'Jakarta',
    rating: 4.5,
  ),
  Restaurant(
    id: '2',
    name: 'Warung Makan',
    description: 'Enak banget',
    pictureId: 'def',
    city: 'Bandung',
    rating: 4.0,
  ),
];

void main() {
  group('RestaurantListProvider', () {
    test(
        '1. State awal provider adalah RestaurantListInitial sebelum fetch selesai',
        () {
      final provider = RestaurantListProvider.withRepository(
          _SuccessRepository(_fakeRestaurants));
      expect(provider.state, isA<RestaurantListInitial>());
    });

    test(
        '2. Mengembalikan daftar restoran ketika pengambilan data API berhasil',
        () async {
      final provider = RestaurantListProvider.withRepository(
          _SuccessRepository(_fakeRestaurants));
      await provider.fetchRestaurants();
      expect(provider.state, isA<RestaurantListSuccess>());
      final state = provider.state as RestaurantListSuccess;
      expect(state.restaurants.length, 2);
      expect(state.restaurants.first.name, 'Kafe Kita');
    });

    test('3. Mengembalikan error ketika pengambilan data API gagal', () async {
      final provider =
          RestaurantListProvider.withRepository(_ErrorRepository());
      await provider.fetchRestaurants();
      expect(provider.state, isA<RestaurantListError>());
      final state = provider.state as RestaurantListError;
      expect(state.message, contains('Tidak ada koneksi internet.'));
    });

    test('4. State berubah ke loading saat sedang mengambil data', () async {
      final states = <RestaurantListState>[];
      final provider = RestaurantListProvider.withRepository(
          _SuccessRepository(_fakeRestaurants));
      provider.addListener(() => states.add(provider.state));
      await provider.fetchRestaurants();
      expect(states.first, isA<RestaurantListLoading>());
      expect(states.last, isA<RestaurantListSuccess>());
    });

    test('5. Daftar restoran kosong ketika API mengembalikan list kosong',
        () async {
      final provider =
          RestaurantListProvider.withRepository(_SuccessRepository([]));
      await provider.fetchRestaurants();
      expect(provider.state, isA<RestaurantListSuccess>());
      final state = provider.state as RestaurantListSuccess;
      expect(state.restaurants, isEmpty);
    });
  });
}
