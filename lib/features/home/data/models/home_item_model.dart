// Data model for Home feature (DTO)
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/entities/home_item.dart';

part 'home_item_model.freezed.dart';
part 'home_item_model.g.dart';

@freezed
abstract class HomeItemModel with _$HomeItemModel {
  const factory HomeItemModel({
    required String id,
    required String title,
    required String description,
    required String iconName,
    required String createdAt,
    @Default(false) bool isFavorite,
  }) = _HomeItemModel;

  factory HomeItemModel.fromJson(Map<String, dynamic> json) => _$HomeItemModelFromJson(json);

  HomeItem toEntity() => HomeItem(
    id: id,
    title: title,
    description: description,
    iconName: iconName,
    createdAt: DateTime.parse(createdAt),
    isFavorite: isFavorite,
  );

  static HomeItemModel fromEntity(HomeItem entity) => HomeItemModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    iconName: entity.iconName,
    createdAt: entity.createdAt.toIso8601String(),
    isFavorite: entity.isFavorite,
  );
}