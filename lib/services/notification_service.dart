import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import '../services/api_service.dart';

const _channelId = 'daily_reminder';
const _channelName = 'Daily Reminder';
const _notifId = 0;
const dailyReminderTask = 'dailyReminderTask';

final _plugin = FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _plugin.initialize(
    const InitializationSettings(android: android, iOS: ios),
  );
}

Future<void> scheduleDaily11AM() async {
  await _plugin.zonedSchedule(
    _notifId,
    'Waktunya Makan Siang! 🍽️',
    'Jangan lupa makan siang. Cek restoran favoritmu sekarang!',
    _nextInstanceOf11AM(),
    NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Pengingat makan siang harian pukul 11.00',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> cancelReminder() async {
  await _plugin.cancel(_notifId);
}

Future<void> registerWorkManagerTask() async {
  await Workmanager().registerPeriodicTask(
    dailyReminderTask,
    dailyReminderTask,
    frequency: const Duration(hours: 24),
    initialDelay: _delayUntil11AM(),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}

Future<void> cancelWorkManagerTask() async {
  await Workmanager().cancelByUniqueName(dailyReminderTask);
}

Duration _delayUntil11AM() {
  final now = tz.TZDateTime.now(tz.local);
  var target = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
  if (target.isBefore(now)) {
    target = target.add(const Duration(days: 1));
  }
  return target.difference(now);
}

tz.TZDateTime _nextInstanceOf11AM() {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

// WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyReminderTask) {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(const InitializationSettings(android: android));
      String title = 'Waktunya Makan Siang! 🍽️';
      String body = 'Jangan lupa makan siang ya!';
      try {
        final restaurants = await ApiService.getRestaurants();
        if (restaurants.isNotEmpty) {
          final r = restaurants[Random().nextInt(restaurants.length)];
          body = 'Coba ${r.name} di ${r.city} hari ini!';
        }
      } catch (_) {}
      await _plugin.show(
        _notifId,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
    return true;
  });
}
