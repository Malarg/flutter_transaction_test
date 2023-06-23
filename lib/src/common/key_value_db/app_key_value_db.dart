import 'dart:async';

abstract interface class AppKeyValueDb {
  Future<bool> containsKey(String key);
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);
  Future<double?> getDouble(String key);
  Future<void> setDouble(String key, double value);
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);
}