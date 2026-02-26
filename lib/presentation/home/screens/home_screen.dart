import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/widgets/product_card.dart';
import '/core/data/repositories/product_repository_impl.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/search_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    final cartCount = ref.watch(cartCountProvider);
    final searchState = ref.watch(searchProvider);

    final categories = ['الكل', 'إلكترونيات', 'ملابس', 'أحذية', 'إكسسوارات'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('مرحباً بك 👋', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text('اكتشف الأفضل', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
        actions: [
          _buildActionIcon(
            context,
            icon: Icons.favorite_outline,
            onTap: () => context.goNamed(AppRoute.favorites.name),
          ),
          _buildCartIcon(context, cartCount),
          _buildActionIcon(
            context,
            icon: Icons.person_outline,
            onTap: () => context.goNamed(AppRoute.profile.name),
          ),
          const SizedBox(width: AppSizes.p16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20, vertical: AppSizes.p16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: TextField(
                onChanged: (value) => ref.read(searchProvider.notifier).updateQuery(value),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن منتجك المفضل...',
                  prefixIcon: Icon(Icons.search, color: AppColors.accent),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = searchState.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => ref.read(searchProvider.notifier).updateCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
                        border: Border.all(color: isSelected ? AppColors.primary : Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.p20),
          Expanded(
            child: productsAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (products) {
                final filtered = products.where((p) {
                  final mQuery = p.title.toLowerCase().contains(searchState.query.toLowerCase());
                  final mCat = searchState.selectedCategory == 'الكل' || p.category == searchState.selectedCategory;
                  return mQuery && mCat;
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: AppSizes.p20,
                    mainAxisSpacing: AppSizes.p20,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => ProductCard(
                    product: filtered[index],
                    onTap: () => context.goNamed(AppRoute.productDetails.name, extra: filtered[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Icon(icon, color: AppColors.textMain, size: 20),
        ),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () => context.goNamed(AppRoute.cart.name),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.textMain, size: 20),
              if (count > 0)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}