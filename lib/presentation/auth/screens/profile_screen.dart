import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../auth/controllers/auth_controller.dart';
import '/core/data/repositories/product_repository_impl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final firestore = ref.watch(firestoreProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('حسابي', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.p32),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accent, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: AppSizes.p16),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
                        ),
                        Text(user.email, style: const TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.p24, vertical: AppSizes.p16),
                    child: Text(
                      'تاريخ الطلبات',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
                    ),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('orders')
                      .where('userId', isEqualTo: user.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                    }
                    
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('لا توجد طلبات سابقة بعد', style: TextStyle(color: AppColors.textSecondary))),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final items = data['items'] as List;
                            final date = DateTime.parse(data['createdAt']);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSizes.p16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                              ),
                              child: ExpansionTile(
                                shape: const RoundedRectangleBorder(side: BorderSide.none),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.accent),
                                ),
                                title: Text('طلب #${docs[index].id.substring(0, 5)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${date.day}/${date.month}/${date.year} • \$${data['totalAmount']}', style: const TextStyle(fontSize: 12)),
                                children: items.map((item) {
                                  return ListTile(
                                    dense: true,
                                    title: Text(item['title']),
                                    trailing: Text('x${item['quantity']} - \$${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                          childCount: docs.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}