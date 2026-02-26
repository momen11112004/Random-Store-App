import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
}

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductEntity(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? '',
          rating: (data['rating'] ?? 0.0).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw Exception('فشل جلب المنتجات من Firestore: $e');
    }
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ProductRepositoryImpl(firestore);
});

final productsProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProducts();
});