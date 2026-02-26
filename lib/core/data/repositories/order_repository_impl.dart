import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../repositories/product_repository_impl.dart'; 
abstract class OrderRepository {
  Future<void> placeOrder(OrderEntity order);
}

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepositoryImpl(this._firestore);

  @override
  Future<void> placeOrder(OrderEntity order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      throw Exception('فشل في إتمام الطلب: $e');
    }
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return OrderRepositoryImpl(firestore);
});