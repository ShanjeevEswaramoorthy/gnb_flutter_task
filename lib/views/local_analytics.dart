import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAnalyticsService {
  static const String _analyticsKey = 'analytics_log';

  Future<void> logEvent(String eventName, Map<String, dynamic> params) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing log
    final rawData = prefs.getString(_analyticsKey) ?? '[]';
    final List<dynamic> events = jsonDecode(rawData);

    // Add new event
    final newEvent = {
      'event': eventName,
      'params': params,
      'timestamp': DateTime.now().toIso8601String(),
    };
    events.add(newEvent);
    await prefs.setString(_analyticsKey, jsonEncode(events));

    print('Analytics event: $newEvent');
  }

  Future<List<Map<String, dynamic>>> getLoggedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_analyticsKey) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(rawData));
  }
}
