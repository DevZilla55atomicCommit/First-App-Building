// Repository interface for Home feature
import '../../core/errors/app_errors.dart';
import '../entities/home_item.dart';

abstract class HomeRepository {
  Future<Result<List<HomeItem>>> getItems();
  Future<Result<HomeItem>> getItem(String id);
  Future<Result<void>> toggleFavorite(String id);
  Future<Result<void>> addItem(HomeItem item);
  Future<Result<void>> deleteItem(String id);
}