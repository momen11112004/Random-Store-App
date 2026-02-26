import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/product_card.dart';
import '/core/data/repositories/product_repository_impl.dart';
import '../controllers/favorites_controller.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('قائمة الأمنيات', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => context.pop(),
        ),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (allProducts) {
          final favProducts = allProducts.where((p) => favIds.contains(p.id)).toList();

          if (favProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('لا توجد منتجات مفضلة بعد', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.goNamed(AppRoute.home.name),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('اكتشف المتجر'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSizes.p20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: AppSizes.p20,
              mainAxisSpacing: AppSizes.p20,
            ),
            itemCount: favProducts.length,
            itemBuilder: (context, index) => ProductCard(
              product: favProducts[index],
              onTap: () => context.pushNamed(AppRoute.productDetails.name, extra: favProducts[index]),
            ),
          );
        },
      ),
    );
  }
}