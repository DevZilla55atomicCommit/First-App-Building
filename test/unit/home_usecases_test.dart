import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:first_app_building/core/errors/app_errors.dart';
import 'package:first_app_building/core/usecase/usecase.dart';
import 'package:first_app_building/features/home/domain/entities/home_item.dart';
import 'package:first_app_building/features/home/domain/repositories/home_repository.dart';
import 'package:first_app_building/features/home/domain/usecases/home_usecases.dart';

// Mock repository
class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetHomeItemsUseCase getHomeItemsUseCase;
  late ToggleFavoriteUseCase toggleFavoriteUseCase;
  late AddHomeItemUseCase addHomeItemUseCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    getHomeItemsUseCase = GetHomeItemsUseCase(mockRepository);
    toggleFavoriteUseCase = ToggleFavoriteUseCase(mockRepository);
    addHomeItemUseCase = AddHomeItemUseCase(mockRepository);
  });

  const testItems = [
    HomeItem(
      id: '1',
      title: 'Test Item 1',
      description: 'Description 1',
      iconName: 'flutter',
      createdAt: DateTime(2024, 1, 1),
    ),
    HomeItem(
      id: '2',
      title: 'Test Item 2',
      description: 'Description 2',
      iconName: 'architecture',
      createdAt: DateTime(2024, 1, 2),
      isFavorite: true,
    ),
  ];

  group('GetHomeItemsUseCase', () {
    test('returns items on success', () async {
      when(() => mockRepository.getItems())
          .thenAnswer((_) async => Result.success(testItems));

      final result = await getHomeItemsUseCase(const NoParams());

      expect(result.isSuccess, true);
      expect(result.dataOrNull, equals(testItems));
      verify(() => mockRepository.getItems()).called(1);
    });

    test('returns error on failure', () async {
      const error = NetworkError('Network failed');
      when(() => mockRepository.getItems())
          .thenAnswer((_) async => Result.failure(error));

      final result = await getHomeItemsUseCase(const NoParams());

      expect(result.isFailure, true);
      expect(result.errorOrNull, equals(error));
    });
  });

  group('ToggleFavoriteUseCase', () {
    test('toggles favorite on success', () async {
      when(() => mockRepository.toggleFavorite('1'))
          .thenAnswer((_) async => const Result.success(null));

      final result = await toggleFavoriteUseCase('1');

      expect(result.isSuccess, true);
      verify(() => mockRepository.toggleFavorite('1')).called(1);
    });

    test('returns error on failure', () async {
      const error = CacheError('Failed to toggle');
      when(() => mockRepository.toggleFavorite('1'))
          .thenAnswer((_) async => Result.failure(error));

      final result = await toggleFavoriteUseCase('1');

      expect(result.isFailure, true);
      expect(result.errorOrNull, equals(error));
    });
  });

  group('AddHomeItemUseCase', () {
    test('adds item on success', () async {
      const newItem = HomeItem(
        id: '3',
        title: 'New Item',
        description: 'New Description',
        iconName: 'riverpod',
        createdAt: DateTime(2024, 1, 3),
      );

      when(() => mockRepository.addItem(newItem))
          .thenAnswer((_) async => const Result.success(null));

      final result = await addHomeItemUseCase(newItem);

      expect(result.isSuccess, true);
      verify(() => mockRepository.addItem(newItem)).called(1);
    });
  });
}