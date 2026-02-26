import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '/core/domain/entities/product_entity.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/favorites_controller.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(product.id);
    final cartItems = ref.watch(cartProvider);
    final isInCart = cartItems.any((item) => item.product.id == product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.45,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.black,
                    ),
                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusExtraLarge)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                        ),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: AppSizes.p24),
                  const Text(
                    'عن المنتج',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSizes.p8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.share_outlined, color: AppColors.textMain),
            ),
            const SizedBox(width: AppSizes.p16),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تمت الإضافة للسلة بنجاح'), behavior: SnackBarBehavior.floating),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  isInCart ? 'أضف المزيد للسلة' : 'إضافة إلى السلة',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}