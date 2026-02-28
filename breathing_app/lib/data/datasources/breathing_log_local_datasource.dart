import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/breathing_log.dart';

class BreathingLogLocalDatasource {
  static const _key = 'breathing_logs';
  final SharedPreferences _prefs;

  BreathingLogLocalDatasource(this._prefs);

  Future<List<BreathingLog>> getAllLogs() async {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => BreathingLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveLog(BreathingLog log) async {
    final logs = await getAllLogs();
    logs.insert(0, log);
    await _prefs.setString(
      _key,
      json.encode(logs.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> deleteLog(String id) async {
    final logs = await getAllLogs();
    logs.removeWhere((l) => l.id == id);
    await _prefs.setString(
      _key,
      json.encode(logs.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearAllLogs() async {
    await _prefs.remove(_key);
  }
}
