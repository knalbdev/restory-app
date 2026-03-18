import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restory_app/data/restaurant_repository.dart';
import 'package:restory_app/models/restaurant.dart';
import 'package:restory_app/providers/favorite_provider.dart';
import 'package:restory_app/providers/restaurant_list_provider.dart';
import 'package:restory_app/providers/settings_provider.dart';
import 'package:restory_app/providers/navigation_provider.dart';
import 'package:restory_app/screens/favorite_screen.dart';
import 'package:restory_app/screens/main_screen.dart';
import 'package:restory_app/screens/settings_screen.dart';

class _EmptyRepository implements RestaurantRepository {
  @override
  Future<List<Restaurant>> getRestaurants() async => [];
}

Widget _buildApp({required Widget home}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) =>
            RestaurantListProvider.withRepository(_EmptyRepository()),
      ),
      ChangeNotifierProvider(create: (_) => FavoriteProvider.forTest()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ],
    child: MaterialApp(home: home),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('1. MainScreen menampilkan bottom navigation bar dengan 3 tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(home: const MainScreen()));
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Restoran'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });

  testWidgets(
      '2. FavoriteScreen menampilkan pesan kosong saat belum ada favorit',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(home: const FavoriteScreen()));
    await tester.pump();

    expect(find.text('Belum ada favorit'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('3. SettingsScreen menampilkan pengaturan mode gelap',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(home: const SettingsScreen()));
    await tester.pump();

    expect(find.text('Mode Gelap'), findsOneWidget);
    expect(find.text('Aktifkan tampilan gelap'), findsOneWidget);
  });

  testWidgets('4. SettingsScreen menampilkan pengaturan pengingat harian',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(home: const SettingsScreen()));
    await tester.pump();

    expect(find.text('Pengingat Makan Siang'), findsOneWidget);
    expect(find.text('Notifikasi harian pukul 11.00'), findsOneWidget);
  });

  testWidgets('5. SettingsScreen memiliki dua switch toggle',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildApp(home: const SettingsScreen()));
    await tester.pump();

    expect(find.byType(SwitchListTile), findsNWidgets(2));
  });
}
