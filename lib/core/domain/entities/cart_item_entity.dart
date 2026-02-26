import 'product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  final int quantity;

  CartItemEntity({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}