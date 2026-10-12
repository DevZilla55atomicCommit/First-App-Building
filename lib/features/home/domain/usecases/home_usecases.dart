// Use case for getting home items
import '../../core/errors/app_errors.dart';
import '../../core/usecase/usecase.dart';
import '../repositories/home_repository.dart';
import '../entities/home_item.dart';

class GetHomeItemsUseCase implements UseCase<List<HomeItem>, NoParams> {
  final HomeRepository _repository;

  GetHomeItemsUseCase(this._repository);

  @override
  Future<Result<List<HomeItem>>> call(NoParams params) async {
    return await _repository.getItems();
  }
}

// Use case for toggling favorite
class ToggleFavoriteUseCase implements UseCase<void, String> {
  final HomeRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  @override
  Future<Result<void>> call(String id) async {
    return await _repository.toggleFavorite(id);
  }
}

// Use case for adding item
class AddHomeItemUseCase implements UseCase<void, HomeItem> {
  final HomeRepository _repository;

  AddHomeItemUseCase(this._repository);

  @override
  Future<Result<void>> call(HomeItem item) async {
    return await _repository.addItem(item);
  }
}