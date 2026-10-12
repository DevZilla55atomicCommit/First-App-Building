// Remote data source for Home feature
import '../models/home_item_model.dart';
import '../../core/errors/app_errors.dart';
import '../../core/network/api_client.dart';

class HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSource(this._apiClient);

  Future<Result<List<HomeItemModel>>> fetchItems() async {
    // In a real app, this would call an API endpoint
    // For demo, we simulate a network delay and return demo data
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate API response with demo data
    final demoItems = HomeItem.demoItems
        .map((e) => HomeItemModel.fromEntity(e))
        .toList();
    
    return Result.success(demoItems);
  }

  Future<Result<HomeItemModel>> fetchItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final item = HomeItem.demoItems.firstWhere((e) => e.id == id, 
      orElse: () => throw NotFoundError(message: 'Item not found'));
    return Result.success(HomeItemModel.fromEntity(item));
  }
}