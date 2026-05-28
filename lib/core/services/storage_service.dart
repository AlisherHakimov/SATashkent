import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveString(String key, String value) => _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> removeString(String key) => _prefs.remove(key);

  Future<void> saveBool(String key, bool value) => _prefs.setBool(key, value);

  bool getBool(String key) => _prefs.getBool(key) ?? false;

  Future<bool> removeBool(String key) => _prefs.remove(key);

  Future<void> saveInt(String key, int value) => _prefs.setInt(key, value);

  Future<void> saveDouble(String key, double value) => _prefs.setDouble(key, value);

  double getDouble(String key) => _prefs.getDouble(key) ?? 0.0;

  Future<void> removeDouble(String key) => _prefs.remove(key);

  Future<void> saveStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  List<String> getStringList(String key) => _prefs.getStringList(key) ?? [];

  Future<bool> removeStringList(String key) => _prefs.remove(key);

  Future<void> saveObject(String key, dynamic value) => _prefs.setString(key, value.toString());

  dynamic getObject(String key) => _prefs.getString(key);

  Future<bool> removeObject(String key) => _prefs.remove(key);

  int getInt(String key) => _prefs.getInt(key) ?? 0;

  Future<bool> removeInt(String key) => _prefs.remove(key);

  Future<bool> clearAll() => _prefs.clear();
}
