import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/app_router.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(radius: 150, backgroundColor: AppColors.accent.withOpacity(0.05)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.green, size: 70),
                  ),
                  const SizedBox(height: AppSizes.p32),
                  const Text(
                    'تم إرسال طلبك!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textMain),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  const Text(
                    'لقد استلمنا طلبك بنجاح. سنقوم بتجهيزه وشحنه إليك في أسرع وقت ممكن.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: AppSizes.p48),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.goNamed(AppRoute.home.name),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('العودة للتسوق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: AppSizes.p16),
                  TextButton(
                    onPressed: () => context.pushNamed(AppRoute.profile.name),
                    child: const Text('عرض تفاصيل الطلب', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}