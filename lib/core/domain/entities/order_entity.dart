import 'cart_item_entity.dart';

class OrderEntity {
  final String id;
  final String userId;
  final List<CartItemEntity> items;
  final double totalAmount;
  final DateTime createdAt;

  OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((item) => {
        'productId': item.product.id,
        'title': item.product.title,
        'price': item.product.price,
        'quantity': item.quantity,
      }).toList(),
    };
  }
}