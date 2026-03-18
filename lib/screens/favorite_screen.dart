import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/restaurant_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: Text('Favorit')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada favorit',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) => RestaurantCard(
              restaurant: provider.favorites[index],
              heroTagPrefix: 'favorite',
            ),
          );
        },
      ),
    );
  }
}
