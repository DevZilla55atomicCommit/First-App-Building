// Domain entity for Home feature
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_item.freezed.dart';
part 'home_item.g.dart';

@freezed
abstract class HomeItem with _$HomeItem {
  const factory HomeItem({
    required String id,
    required String title,
    required String description,
    required String iconName,
    required DateTime createdAt,
    @Default(false) bool isFavorite,
  }) = _HomeItem;

  factory HomeItem.fromJson(Map<String, dynamic> json) => _$HomeItemFromJson(json);
}

// Example items for demo
extension HomeItemDemo on HomeItem {
  static List<HomeItem> get demoItems => [
    HomeItem(
      id: '1',
      title: 'Welcome to Flutter',
      description: 'Build beautiful native apps in record time',
      iconName: 'flutter',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isFavorite: true,
    ),
    HomeItem(
      id: '2',
      title: 'Clean Architecture',
      description: 'Separate concerns for maintainable code',
      iconName: 'architecture',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    HomeItem(
      id: '3',
      title: 'Riverpod State Management',
      description: 'Type-safe, compile-safe dependency injection',
      iconName: 'riverpod',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isFavorite: true,
    ),
    HomeItem(
      id: '4',
      title: 'iOS Simulator Ready',
      description: 'Test on iPhone 16 with iOS 27',
      iconName: 'iphone',
      createdAt: DateTime.now(),
    ),
  ];
}