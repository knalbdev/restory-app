import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_search_provider.dart';
import '../widgets/restaurant_card.dart';

class RestaurantSearchScreen extends StatelessWidget {
  const RestaurantSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantSearchProvider(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Cari restoran...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
          ),
          onChanged: (query) =>
              context.read<RestaurantSearchProvider>().search(query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            tooltip: 'Hapus',
            onPressed: () {
              _controller.clear();
              context.read<RestaurantSearchProvider>().search('');
            },
          ),
        ],
      ),
      body: Consumer<RestaurantSearchProvider>(
        builder: (context, provider, _) {
          return switch (provider.state) {
            RestaurantSearchInitial() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Cari restoran favoritmu',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            RestaurantSearchLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantSearchSuccess(restaurants: final restaurants) =>
              restaurants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Restoran tidak ditemukan',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : _buildResults(context, restaurants),
            RestaurantSearchError(message: final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Pencarian Gagal',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context, List<Restaurant> restaurants) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) => RestaurantCard(
        restaurant: restaurants[index],
        heroTagPrefix: 'search',
      ),
    );
  }
}
