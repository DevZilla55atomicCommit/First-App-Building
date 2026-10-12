// ViewModel for Home feature using Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/errors/app_errors.dart';
import '../../core/usecase/usecase.dart';
import '../domain/usecases/home_usecases.dart';
import '../domain/entities/home_item.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  AsyncValue<List<HomeItem>> build() {
    // Initial load
    _loadItems();
    return const AsyncValue.loading();
  }

  Future<void> _loadItems() async {
    final getItemsUseCase = ref.read(getHomeItemsUseCaseProvider);
    final result = await getItemsUseCase(const NoParams());
    
    result.when(
      success: (items) => state = AsyncValue.data(items),
      failure: (error) => state = AsyncValue.error(error, StackTrace.current),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadItems();
  }

  Future<void> toggleFavorite(String id) async {
    final currentItems = state.valueOrNull ?? [];
    final itemIndex = currentItems.indexWhere((e) => e.id == id);
    if (itemIndex == -1) return;

    // Optimistic update
    final updatedItems = List<HomeItem>.from(currentItems);
    final item = updatedItems[itemIndex];
    updatedItems[itemIndex] = HomeItem(
      id: item.id,
      title: item.title,
      description: item.description,
      iconName: item.iconName,
      createdAt: item.createdAt,
      isFavorite: !item.isFavorite,
    );
    state = AsyncValue.data(updatedItems);

    // Actual API call
    final toggleUseCase = ref.read(toggleFavoriteUseCaseProvider);
    final result = await toggleUseCase(id);
    
    if (result.isFailure) {
      // Revert on failure
      state = AsyncValue.data(currentItems);
    }
  }

  Future<void> addItem(HomeItem item) async {
    final currentItems = state.valueOrNull ?? [];
    state = AsyncValue.data([item, ...currentItems]);
    
    final addUseCase = ref.read(addHomeItemUseCaseProvider);
    final result = await addUseCase(item);
    
    if (result.isFailure) {
      state = AsyncValue.data(currentItems);
    }
  }

  Future<void> deleteItem(String id) async {
    final currentItems = state.valueOrNull ?? [];
    final itemToDelete = currentItems.firstWhere((e) => e.id == id, orElse: () => throw 'Item not found');
    state = AsyncValue.data(currentItems.where((e) => e.id != id).toList());
    
    // In a real app, you'd have a delete use case
    // For demo, we just keep the local change
  }
}

// Providers for use cases
@riverpod
GetHomeItemsUseCase getHomeItemsUseCase(GetHomeItemsUseCaseRef ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeItemsUseCase(repository);
}

@riverpod
ToggleFavoriteUseCase toggleFavoriteUseCase(ToggleFavoriteUseCaseRef ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return ToggleFavoriteUseCase(repository);
}

@riverpod
AddHomeItemUseCase addHomeItemUseCase(AddHomeItemUseCaseRef ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return AddHomeItemUseCase(repository);
}

// Repository provider
@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  final localDataSource = ref.watch(homeLocalDataSourceProvider);
  return HomeRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}

@riverpod
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRemoteDataSource(apiClient);
}

@riverpod
HomeLocalDataSource homeLocalDataSource(HomeLocalDataSourceRef ref) {
  final localStorage = ref.watch(localStorageProvider);
  return HomeLocalDataSource(localStorage);
}