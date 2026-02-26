import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_sizes.dart';
import '../controllers/cart_controller.dart';
import '/core/domain/entities/order_entity.dart';
import '../../auth/controllers/auth_controller.dart';
import '/core/data/repositories/order_repository_impl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('حقيبة التسوق', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.p20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.p16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: item.product.imageUrl,
                          width: 80, height: 80, fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSizes.p16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('\$${item.product.price}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _quantityBtn(Icons.remove, () => ref.read(cartProvider.notifier).decrementQuantity(item.product.id)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          _quantityBtn(Icons.add, () => ref.read(cartProvider.notifier).addProduct(item.product)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty ? null : _buildCheckoutPanel(context, ref, totalAmount, cartItems),
    );
  }

  Widget _quantityBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.textMain),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('حقيبتك فارغة تماماً', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel(BuildContext context, WidgetRef ref, double total, dynamic items) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي المستحق', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final user = ref.read(authStateProvider).value;
                if (user == null) return;
                final order = OrderEntity(id: '', userId: user.id, items: items, totalAmount: total, createdAt: DateTime.now());
                try {
                  await ref.read(orderRepositoryProvider).placeOrder(order);
                  ref.read(cartProvider.notifier).clearCart();
                  if (context.mounted) context.goNamed(AppRoute.orderSuccess.name);
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('إتمام عملية الشراء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}