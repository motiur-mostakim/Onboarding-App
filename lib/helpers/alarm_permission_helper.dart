import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionHelper {
  static const MethodChannel _channel = MethodChannel('exact_alarm');

  static Future<void> requestExactAlarmPermission() async {
    try {
      final result = await _channel.invokeMethod('requestPermission');
      print('Exact alarm permission result: $result');
    } catch (e) {
      print('Error requesting exact alarm permission: $e');
    }
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
    } else {}
  }
}
