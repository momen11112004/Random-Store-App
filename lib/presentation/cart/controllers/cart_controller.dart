import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/domain/entities/cart_item_entity.dart';
import '/core/domain/entities/product_entity.dart';

class CartController extends StateNotifier<List<CartItemEntity>> {
  CartController() : super([]);

  void addProduct(ProductEntity product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final updatedCart = List<CartItemEntity>.from(state);
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      state = [...state, CartItemEntity(product: product, quantity: 1)];
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void decrementQuantity(String productId) {
    final existingIndex = state.indexWhere((item) => item.product.id == productId);
    
    if (existingIndex >= 0) {
      final item = state[existingIndex];
      if (item.quantity > 1) {
        final updatedCart = List<CartItemEntity>.from(state);
        updatedCart[existingIndex] = item.copyWith(quantity: item.quantity - 1);
        state = updatedCart;
      } else {
        removeProduct(productId);
      }
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartController, List<CartItemEntity>>((ref) {
  return CartController();
});

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
});

final cartCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (count, item) => count + item.quantity);
});