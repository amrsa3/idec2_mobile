import 'dart:convert';
import 'platform_storage_service.dart';

/// Abstract storage service interface
abstract class StorageService {
  Future<void> init();
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);
  Future<double?> getDouble(String key);
  Future<void> setDouble(String key, double value);
  Future<List<String>?> getStringList(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<bool> containsKey(String key);
  Future<Map<String, String>> readBatch(List<String> keys);
  Future<void> writeBatch(Map<String, String> data);
  Future<void> remove(String key);
}

/// Default implementation using PlatformStorageService
class DefaultStorageService extends StorageService {
  final PlatformStorageService _platformStorage = PlatformStorageService.instance;

  @override
  Future<void> init() => _platformStorage.init();

  @override
  Future<String?> read(String key) => _platformStorage.read(key);

  @override
  Future<void> write(String key, String value) => _platformStorage.write(key, value);

  @override
  Future<void> delete(String key) => _platformStorage.delete(key);

  @override
  Future<void> clear() => _platformStorage.clear();

  @override
  Future<String?> getString(String key) => _platformStorage.getString(key);

  @override
  Future<void> setString(String key, String value) => _platformStorage.setString(key, value);

  @override
  Future<bool?> getBool(String key) => _platformStorage.getBool(key);

  @override
  Future<void> setBool(String key, bool value) => _platformStorage.setBool(key, value);

  @override
  Future<int?> getInt(String key) => _platformStorage.getInt(key);

  @override
  Future<void> setInt(String key, int value) => _platformStorage.setInt(key, value);

  @override
  Future<double?> getDouble(String key) => _platformStorage.getDouble(key);

  @override
  Future<void> setDouble(String key, double value) => _platformStorage.setDouble(key, value);

  @override
  Future<List<String>?> getStringList(String key) async {
    // PlatformStorageService doesn't have getStringList, so we'll implement it
    final value = await _platformStorage.getString(key);
    if (value == null) return null;
    try {
      final List<dynamic> list = json.decode(value);
      return list.cast<String>();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    // PlatformStorageService doesn't have setStringList, so we'll implement it
    final jsonString = json.encode(value);
    await _platformStorage.setString(key, jsonString);
  }

  @override
  Future<bool> containsKey(String key) => _platformStorage.containsKey(key);

  @override
  Future<Map<String, String>> readBatch(List<String> keys) => _platformStorage.readBatch(keys);

  @override
  Future<void> writeBatch(Map<String, String> data) => _platformStorage.writeBatch(data);

  @override
  Future<void> remove(String key) => _platformStorage.delete(key);
}