// Repository implementation for Home feature
import '../../core/errors/app_errors.dart';
import '../datasources/home_remote_data_source.dart';
import '../datasources/home_local_data_source.dart';
import '../models/home_item_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/home_item.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Result<List<HomeItem>>> getItems() async {
    // Try local cache first
    final localResult = await _localDataSource.getCachedItems();
    if (localResult.isSuccess && localResult.dataOrNull!.isNotEmpty) {
      return Result.success(localResult.dataOrNull!.map((e) => e.toEntity()).toList());
    }

    // Fallback to remote
    final remoteResult = await _remoteDataSource.fetchItems();
    if (remoteResult.isFailure) {
      return Result.failure(remoteResult.errorOrNull!);
    }

    // Cache the remote data
    await _localDataSource.cacheItems(remoteResult.dataOrNull!);
    
    return Result.success(remoteResult.dataOrNull!.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Result<HomeItem>> getItem(String id) async {
    final remoteResult = await _remoteDataSource.fetchItem(id);
    if (remoteResult.isFailure) {
      return Result.failure(remoteResult.errorOrNull!);
    }
    return Result.success(remoteResult.dataOrNull!.toEntity());
  }

  @override
  Future<Result<void>> toggleFavorite(String id) async {
    return await _localDataSource.toggleFavorite(id);
  }

  @override
  Future<Result<void>> addItem(HomeItem item) async {
    // For demo, we just update local storage
    final localResult = await _localDataSource.getCachedItems();
    List<HomeItemModel> items = localResult.isSuccess ? localResult.dataOrNull! : [];
    items.insert(0, HomeItemModel.fromEntity(item));
    return await _localDataSource.cacheItems(items);
  }

  @override
  Future<Result<void>> deleteItem(String id) async {
    final localResult = await _localDataSource.getCachedItems();
    if (localResult.isFailure) {
      return Result.failure(localResult.errorOrNull!);
    }
    final items = localResult.dataOrNull!.where((e) => e.id != id).toList();
    return await _localDataSource.cacheItems(items);
  }
}