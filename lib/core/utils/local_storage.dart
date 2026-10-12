// Shared preferences wrapper for local storage
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/app_errors.dart';

class LocalStorage {
  static const String _prefix = 'first_app_';

  Future<Result<void>> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$key', value);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to save string: $e', originalError: e));
    }
  }

  Future<Result<String?>> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Result.success(prefs.getString('$_prefix$key'));
    } catch (e) {
      return Result.failure(CacheError('Failed to get string: $e', originalError: e));
    }
  }

  Future<Result<void>> setBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_prefix$key', value);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to save bool: $e', originalError: e));
    }
  }

  Future<Result<bool>> getBool(String key, {bool defaultValue = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Result.success(prefs.getBool('$_prefix$key') ?? defaultValue);
    } catch (e) {
      return Result.failure(CacheError('Failed to get bool: $e', originalError: e));
    }
  }

  Future<Result<void>> setInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$_prefix$key', value);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to save int: $e', originalError: e));
    }
  }

  Future<Result<int>> getInt(String key, {int defaultValue = 0}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return Result.success(prefs.getInt('$_prefix$key') ?? defaultValue);
    } catch (e) {
      return Result.failure(CacheError('Failed to get int: $e', originalError: e));
    }
  }

  Future<Result<void>> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix$key');
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to remove: $e', originalError: e));
    }
  }

  Future<Result<void>> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
      for (final key in keys) {
        await prefs.remove(key);
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to clear: $e', originalError: e));
    }
  }
}