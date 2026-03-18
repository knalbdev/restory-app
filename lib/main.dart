import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'providers/favorite_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/restaurant_list_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/main_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Workmanager().initialize(callbackDispatcher);
  runApp(const RestoryApp());
}

class RestoryApp extends StatelessWidget {
  const RestoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantListProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Restory App',
            debugShowCheckedModeBanner: false,
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            themeMode: settings.themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }

  ThemeData _lightTheme() {
    const primary = Color(0xFFE65100);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  ThemeData _darkTheme() {
    const primary = Color(0xFFFF6D00);
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
    );
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1C1C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
