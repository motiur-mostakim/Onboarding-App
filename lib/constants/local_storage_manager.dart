import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(String key, dynamic value) async {
    if (value is int) {
      _prefs?.setInt(key, value);
    } else if (value is String) {
      _prefs?.setString(key, value);
    } else if (value is bool) {
      _prefs?.setBool(key, value);
    } else {
      log("Invalid Type");
    }
  }

  static Future<dynamic> readData(String key) async {
    dynamic obj = _prefs?.get(key);
    return obj;
  }

  static Future<Future<bool>?> deleteData(String key) async {
    return _prefs?.remove(key);
  }

  Future<void> saveAlarms(List<DateTime> alarms) async {
    List<String> alarmStrings = alarms.map((e) => e.toIso8601String()).toList();
    await _prefs?.setStringList('alarms', alarmStrings);
  }

  Future<List<DateTime>> loadAlarms() async {
    List<String>? alarmStrings = _prefs?.getStringList('alarms');
    if (alarmStrings != null) {
      return alarmStrings.map((e) => DateTime.parse(e)).toList();
    }
    return [];
  }
}
