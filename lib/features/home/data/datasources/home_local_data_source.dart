// Local data source for Home feature (using SharedPreferences)
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_item_model.dart';
import '../../core/errors/app_errors.dart';
import '../../core/utils/local_storage.dart';

class HomeLocalDataSource {
  final LocalStorage _storage;
  static const String _itemsKey = 'home_items';
  static const String _favoritesKey = 'home_favorites';

  HomeLocalDataSource(this._storage);

  Future<Result<List<HomeItemModel>>> getCachedItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = prefs.getStringList('$_prefix$_itemsKey') ?? [];
      final items = itemsJson
          .map((e) => HomeItemModel.fromJson(jsonDecode(e)))
          .toList();
      return Result.success(items);
    } catch (e) {
      return Result.failure(CacheError('Failed to get cached items: $e', originalError: e));
    }
  }

  Future<Result<void>> cacheItems(List<HomeItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itemsJson = items.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('$_prefix$_itemsKey', itemsJson);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to cache items: $e', originalError: e));
    }
  }

  Future<Result<Set<String>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('$_prefix$_favoritesKey') ?? [];
      return Result.success(favorites.toSet());
    } catch (e) {
      return Result.failure(CacheError('Failed to get favorites: $e', originalError: e));
    }
  }

  Future<Result<void>> toggleFavorite(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('$_prefix$_favoritesKey') ?? [];
      final favoritesSet = favorites.toSet();
      
      if (favoritesSet.contains(id)) {
        favoritesSet.remove(id);
      } else {
        favoritesSet.add(id);
      }
      
      await prefs.setStringList('$_prefix$_favoritesKey', favoritesSet.toList());
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheError('Failed to toggle favorite: $e', originalError: e));
    }
  }
}