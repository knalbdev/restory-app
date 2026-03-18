import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

const _keyDarkMode = 'dark_mode';
const _keyDailyReminder = 'daily_reminder';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isDailyReminderEnabled = false;

  bool get isDarkMode => _isDarkMode;
  bool get isDailyReminderEnabled => _isDailyReminderEnabled;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_keyDarkMode) ?? false;
    _isDailyReminderEnabled = prefs.getBool(_keyDailyReminder) ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<void> setDailyReminder(bool value) async {
    _isDailyReminderEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDailyReminder, value);
    if (value) {
      await scheduleDaily11AM();
      await registerWorkManagerTask();
    } else {
      await cancelReminder();
      await cancelWorkManagerTask();
    }
  }
}
