import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_list_provider.dart';
import 'restaurant_search_screen.dart';
import '../widgets/about_developer_dialog.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari Restoran',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RestaurantSearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tentang Developer',
            onPressed: () => AboutDeveloperDialog.show(context),
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, _) {
          return switch (provider.state) {
            RestaurantListInitial() => const SizedBox.shrink(),
            RestaurantListLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantListSuccess(restaurants: final restaurants) =>
              _buildList(context, restaurants, provider),
            RestaurantListError(message: final message) =>
              _buildError(context, message, provider),
          };
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<Restaurant> restaurants,
    RestaurantListProvider provider,
  ) {
    return RefreshIndicator(
      onRefresh: provider.fetchRestaurants,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey there! 👋',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Where will you eat today?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => RestaurantCard(
                  restaurant: restaurants[index], heroTagPrefix: 'list'),
              childCount: restaurants.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    RestaurantListProvider provider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: provider.fetchRestaurants,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
