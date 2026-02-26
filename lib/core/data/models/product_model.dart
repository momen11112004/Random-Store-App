import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required double rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => 
      _$ProductModelFromJson(json);
}

extension ProductModelX on ProductModel {
  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        category: category,
        rating: rating,
      );
}