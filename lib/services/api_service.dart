import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  static String imageUrl(String pictureId, {String size = 'medium'}) {
    return '$_baseUrl/images/$size/$pictureId';
  }

  static Exception _networkError() {
    return Exception(
      'Tidak ada koneksi internet. Periksa jaringan Anda dan coba lagi.',
    );
  }

  static Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/list'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List restaurants = data['restaurants'] as List;
        return restaurants
            .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Gagal memuat daftar restoran. Silakan coba lagi.');
    } on SocketException {
      throw _networkError();
    } on http.ClientException {
      throw _networkError();
    }
  }

  static Future<RestaurantDetail> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return RestaurantDetail.fromJson(
          data['restaurant'] as Map<String, dynamic>,
        );
      }
      throw Exception('Gagal memuat detail restoran. Silakan coba lagi.');
    } on SocketException {
      throw _networkError();
    } on http.ClientException {
      throw _networkError();
    }
  }

  static Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List restaurants = data['restaurants'] as List;
        return restaurants
            .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Gagal mencari restoran. Silakan coba lagi.');
    } on SocketException {
      throw _networkError();
    } on http.ClientException {
      throw _networkError();
    }
  }

  static Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'name': name, 'review': review}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List reviews = data['customerReviews'] as List;
        return reviews
            .map((e) => CustomerReview.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Gagal menambahkan ulasan. Silakan coba lagi.');
    } on SocketException {
      throw _networkError();
    } on http.ClientException {
      throw _networkError();
    }
  }
}
