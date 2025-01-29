import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserData(Map<String, dynamic> userData) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Save each field separately
  for (var entry in userData.entries) {
    if (entry.value is String) {
      await prefs.setString(entry.key, entry.value);
    } else if (entry.value is int) {
      await prefs.setInt(entry.key, entry.value);
    } else if (entry.value is bool) {
      await prefs.setBool(entry.key, entry.value == "true");
    } else if (entry.value is double) {
      await prefs.setDouble(entry.key, entry.value);
    } else if (entry.value == null) {
      await prefs.remove(entry.key);
    } else {
      await prefs.setString(entry.key, jsonEncode(entry.value));
    }
  }
}
