import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/gradient_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: Text('Pengaturan')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Mode Gelap'),
                subtitle: const Text('Aktifkan tampilan gelap'),
                secondary: Icon(
                    settings.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                value: settings.isDarkMode,
                onChanged: settings.setDarkMode,
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Pengingat Makan Siang'),
                subtitle: const Text('Notifikasi harian pukul 11.00'),
                secondary: Icon(
                  settings.isDailyReminderEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                ),
                value: settings.isDailyReminderEnabled,
                onChanged: settings.setDailyReminder,
              ),
            ],
          );
        },
      ),
    );
  }
}
