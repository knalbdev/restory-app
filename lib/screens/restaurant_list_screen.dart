import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_list_provider.dart';
import 'restaurant_search_screen.dart';
import '../widgets/about_developer_dialog.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, provider, _) {
        return switch (provider.state) {
          RestaurantListInitial() || RestaurantListLoading() => Scaffold(
              appBar: _simpleAppBar(context),
              body: const Center(child: CircularProgressIndicator()),
            ),
          RestaurantListSuccess(restaurants: final restaurants) =>
            _buildSuccess(context, restaurants, provider),
          RestaurantListError(message: final message) => Scaffold(
              appBar: _simpleAppBar(context),
              body: _buildError(context, message, provider),
            ),
        };
      },
    );
  }

  GradientAppBar _simpleAppBar(BuildContext context) {
    return GradientAppBar(
      title: const Text('Restory'),
      actions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) {
    return [
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
    ];
  }

  Widget _buildSuccess(
    BuildContext context,
    List<Restaurant> restaurants,
    RestaurantListProvider provider,
  ) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: provider.fetchRestaurants,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              forceElevated: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              actions: _actions(context),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 20),
                title: const Text(
                  'Restory',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primary,
                          Color.lerp(primary, Colors.black, 0.3)!,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 52),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Temukan restoran favoritmu 🍽️',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RestaurantCard(
                    restaurant: restaurants[index],
                    heroTagPrefix: 'list',
                  ),
                  childCount: restaurants.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
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
