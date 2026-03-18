import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import 'restaurant_list_screen.dart';
import 'favorite_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const _screens = [
    RestaurantListScreen(),
    FavoriteScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    return Scaffold(
      body: IndexedStack(
        index: nav.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.currentIndex,
        onDestinationSelected: context.read<NavigationProvider>().setIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Restoran',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
