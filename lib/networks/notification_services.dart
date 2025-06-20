import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));
    tz.initializeTimeZones();
  }

  static scheduleNotification(
      String title, String body, DateTime scheduleTime) async {
    var androidDetails = const AndroidNotificationDetails(
        'important_notifications', 'My Channel',
        importance: Importance.max, priority: Priority.high);

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    final tz.TZDateTime tzScheduledDate =
        tz.TZDateTime.from(scheduleTime, tz.local);

    await _notification.zonedSchedule(
        0, title, body, tzScheduledDate, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
